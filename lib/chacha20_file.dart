import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:m511chacha20/file_list_encryption_promise.dart';

import 'cha_cha_20_algorithm.dart';
import 'cipher_result.dart';
import 'file_encryption_promise.dart';
import 'nonce.dart';

typedef OnCipherFinished = Function(CipherResult cipherResult);

/// Encrypts or decrypts a single File using the ChaCha20 algorithm
Future<CipherResult> cipherSingleFile({
  required String filePath,
  required String outputFilePath,
  required Nonce nonce,
  required Uint32List password,
}) async {
  final input = File(filePath).openRead();
  final output = File(outputFilePath).openWrite();
  final completer = Completer<CipherResult>();

  try {
    await for (var chunk in input) {
      var processedChunk = ChaCha20Algorithm(password, 0, nonce.intList)
          .processBytes(Uint8List.fromList(chunk));
      await output.addStream(Stream.fromIterable([processedChunk]));
    }

    await output.flush();
    await output.close();

    completer.complete(CipherResult(File(outputFilePath), true));
  } catch (e) {
    completer.completeError(e);
  }

  return completer.future;
}

void executeFileListEncryptionPromise(List<dynamic> message) {
  SendPort sendPort = message[0];
  FileListEncryptionPromise fileListEncryptionPromise =
      FileListEncryptionPromise.unserialize(message[1]);

  for (FileEncryptionPromise fileEncryptionPromise
      in fileListEncryptionPromise.filePromises) {
    cipherSingleFile(
            filePath: fileEncryptionPromise.inputFile,
            outputFilePath: fileEncryptionPromise.outputFile,
            nonce: fileEncryptionPromise.nonce,
            password: fileEncryptionPromise.password)
        .then(
            (CipherResult cipherResult) => sendPort.send(cipherResult.toMap()));
  }
}

Future<ReceivePort> computeFileListEncryptionPromiseWithPorts(
  SendPort sendPort,
  FileListEncryptionPromise fileListEncryptionPromise,
) async {
  ReceivePort receivePort = ReceivePort();

  await Isolate.spawn(
    executeFileListEncryptionPromise,
    [receivePort.sendPort, fileListEncryptionPromise.serialize()],
  );

  return receivePort;
}

Future<bool> computeFileListEncryptionPromise(
    FileListEncryptionPromise fileListEncryptionPromise,
    {OnCipherFinished? onCipherFinished}) async {
  Completer<bool> encryptAllFilesCompleter = Completer();
  ReceivePort receivePort = await computeFileListEncryptionPromiseWithPorts(
    Isolate.current.controlPort,
    fileListEncryptionPromise,
  );

  int expectedResultsCount = fileListEncryptionPromise.filePromises.length;
  bool allSuccess = true;
  // Listen for results from the receive port
  await for (var result in receivePort) {
    // Process each result as it arrives
    CipherResult cipherResult = CipherResult.fromMap(result);
    if (onCipherFinished != null) {
      onCipherFinished(CipherResult.fromMap(result));
    }
    if (!cipherResult.success) allSuccess = false;
    expectedResultsCount--;
    if (expectedResultsCount == 0) {
      receivePort.close();
      encryptAllFilesCompleter.complete(allSuccess);
    }
  }

  return encryptAllFilesCompleter.future;
}
