import 'dart:convert';
import 'dart:typed_data';

import 'package:m511chacha20/cha_cha_20_algorithm.dart';
import 'package:m511chacha20/chacha20_key.dart';
import 'package:m511chacha20/nonce.dart';

class ChaCha20 {
  late Uint32List _password;

  ChaCha20(ChaCha20Key password) {
    _password = password.data;
  }

  String decrypt(String cipherText, Nonce nonce) {
    ChaCha20Algorithm chaCha20Algorithm =
        ChaCha20Algorithm(_password, 0, nonce.intList);
    Uint8List inputBytes = base64Decode(cipherText);
    return String.fromCharCodes(chaCha20Algorithm.processBytes(inputBytes));
  }

  String encrypt(String plainText, Nonce nonce) {
    ChaCha20Algorithm chaCha20Algorithm =
        ChaCha20Algorithm(_password, 0, nonce.intList);
    Uint8List inputBytes = Uint8List.fromList(plainText.codeUnits);
    return base64Encode(chaCha20Algorithm.processBytes(inputBytes));
  }

  String encryptMap(Map<String, dynamic> data, Nonce nonce) =>
      encrypt(jsonEncode(data), nonce);
  Map<String, dynamic> decryptMap(String cipherText, Nonce nonce) =>
      jsonDecode(decrypt(cipherText, nonce));
}
