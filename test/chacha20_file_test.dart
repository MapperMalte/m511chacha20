import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:m511chacha20/chacha20_file.dart';
import 'package:m511chacha20/chacha20_key.dart';
import 'package:m511chacha20/cipher_result.dart';
import 'package:m511chacha20/file_encryption_promise.dart';
import 'package:m511chacha20/file_list_encryption_promise.dart';
import 'package:m511chacha20/key_pair.dart';
import 'package:m511chacha20/nonce.dart';

void main() {
  test('ChaCha20File encrypts and unencrypts file', () async {
    Nonce nonce = Nonce.fromString("Some String for a nonce");
    Uint32List key = ChaCha20Key.fromBigInt(KeyPair.randomBigInt(512)).data;
    bool finishCalled = false;
    bool success1 = await computeFileListEncryptionPromise(
        FileListEncryptionPromise(filePromises: [
          FileEncryptionPromise(
              inputFile: "test/test_files/plaintext_example.txt",
              nonce: nonce,
              password: key,
              outputFile: "test/test_files/encrypted_example.txt")
        ]), onCipherFinished: (CipherResult cipherResult) {
      finishCalled = true;
    });
    expect(success1 && finishCalled, true);

    bool success2 = await computeFileListEncryptionPromise(
        FileListEncryptionPromise(filePromises: [
      FileEncryptionPromise(
          inputFile: "test/test_files/encrypted_example.txt",
          nonce: nonce,
          password: key,
          outputFile: "test/test_files/unencrypted_example.txt")
    ]));

    expect(success2, true);
    Uint8List sourceBytes =
        File("test/test_files/plaintext_example.txt").readAsBytesSync();
    Uint8List targetBytes =
        File("test/test_files/unencrypted_example.txt").readAsBytesSync();
    expect(sourceBytes, targetBytes);
  });
}
