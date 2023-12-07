import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class Nonce {
  Uint32List intList;
  Nonce(this.intList);

  /// Hashes the UUID with sha256 and uses parts of the hash to create a nonce
  static Nonce fromUUID(String uuidStr) {
    return Nonce.fromBytes(sha256
        .convert(utf8.encode(String.fromCharCodes(Uuid.parse(uuidStr))))
        .bytes);
  }

  /// Creates a nonce from a string
  static Nonce fromString(String str) {
    return Nonce.fromBytes(sha256.convert(str.codeUnits).bytes);
  }

  /// takes 12 bytes of the input, which is expected to be a list of bytes, and makes a nonce from it
  /// expects the input bytes to be completely random!
  static Nonce fromBytes(List<int> bytes) {
    return Nonce(
        Uint8List.fromList(bytes.sublist(0, 12)).buffer.asUint32List());
  }

  /// Creates a nonce from three random integers.
  static Nonce fromThreeInts(int a, int b, int c) {
    return Nonce(Uint32List.fromList([a, b, c]));
  }
}
