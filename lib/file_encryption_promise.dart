import 'dart:typed_data';

import 'nonce.dart';

/// A wrapper class to pass the relevant paramters for file encryption between CPU cores
class FileEncryptionPromise {
  final String inputFile;
  final Nonce nonce;
  final Uint32List password;
  final String outputFile;

  FileEncryptionPromise({
    required this.inputFile,
    required this.nonce,
    required this.password,
    required this.outputFile,
  });
}
