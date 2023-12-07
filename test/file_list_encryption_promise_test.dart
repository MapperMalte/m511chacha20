import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:m511chacha20/chacha20_key.dart';
import 'package:m511chacha20/file_encryption_promise.dart';
import 'package:m511chacha20/file_list_encryption_promise.dart';
import 'package:m511chacha20/nonce.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('FileListEncryptionPromise is correctly serialized and unserialized',
      () {
    Uint32List password =
        ChaCha20Key.fromInts([123, 12312, 123, 435, 567, 768, 678, 678]).data;
    FileListEncryptionPromise fileListEncryptionPromise =
        FileListEncryptionPromise(filePromises: [
      FileEncryptionPromise(
          inputFile: "inputFile1",
          nonce: Nonce.fromUUID(const Uuid().v1()),
          password: password,
          outputFile: "outputFile1"),
      FileEncryptionPromise(
          inputFile: "inputFile2",
          nonce: Nonce.fromUUID(const Uuid().v1()),
          password: password,
          outputFile: "outputFile2")
    ]);
    FileListEncryptionPromise unserialized =
        FileListEncryptionPromise.unserialize(
            fileListEncryptionPromise.serialize());
    for (int i = 0; i < unserialized.filePromises.length; i++) {
      expect(fileListEncryptionPromise.filePromises[i].outputFile,
          unserialized.filePromises[i].outputFile);
      expect(fileListEncryptionPromise.filePromises[i].nonce,
          unserialized.filePromises[i].nonce);
      expect(fileListEncryptionPromise.filePromises[i].password,
          unserialized.filePromises[i].password);
      expect(fileListEncryptionPromise.filePromises[i].inputFile,
          unserialized.filePromises[i].inputFile);
    }
  });
}
