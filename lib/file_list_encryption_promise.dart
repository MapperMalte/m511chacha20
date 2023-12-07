import 'file_encryption_promise.dart';

/// A wrapper class to pass the relevant paramters for file encryption between CPU cores
class FileListEncryptionPromise {
  final List<FileEncryptionPromise> filePromises;

  FileListEncryptionPromise({
    required this.filePromises,
  });

  Map<String, dynamic> serialize() {
    return {
      'filePromises': [
        for (var promise in filePromises)
          {
            'inputFile': promise.inputFile,
            'nonce': promise.nonce,
            'password': promise.password,
            'outputFile': promise.outputFile,
          },
      ],
    };
  }

  /// unserialize a map to a FileListEncryptionPromise
  static FileListEncryptionPromise unserialize(Map<String, dynamic> data) {
    List<FileEncryptionPromise> filePromises = [
      for (var entry in data['filePromises'])
        FileEncryptionPromise(
          inputFile: entry['inputFile'],
          nonce: entry['nonce'],
          password: entry['password'],
          outputFile: entry['outputFile'],
        ),
    ];

    return FileListEncryptionPromise(filePromises: filePromises);
  }
}
