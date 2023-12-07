import 'dart:io';

/// The result of a file encryption in ChaCha20 File module
class CipherResult {
  late File cipherFile;
  late bool success;

  CipherResult(this.cipherFile, this.success);
  CipherResult.fromMap(Map<String, dynamic> map) {
    cipherFile = File(map['file']);
    success = map['success'];
  }

  Map<String, dynamic> toMap() {
    return {'file': cipherFile.path, 'success': success};
  }
}
