import 'dart:typed_data';

class ChaCha20Key {
  late Uint32List data = Uint32List(3);

  /// takes the first 8 integers and exoects them to be Uint32
  ChaCha20Key.fromInts(List<int> ints) {
    assert(ints.length >= 8);
    data = Uint32List.fromList(ints.sublist(0, 8));
  }

  /// takes 256 bit from the BigInt
  ChaCha20Key.fromBigInt(BigInt bigInt) {
    data = Uint32List.fromList(bigInt
        .toRadixString(32)
        .runes
        .map((rune) => int.parse(String.fromCharCode(rune), radix: 32))
        .toList()
        .sublist(0, 8));
  }

  /// equivalent to ChaCha20Key.fromInts(key.codeUnits)
  static ChaCha20Key fromString(String key) =>
      ChaCha20Key.fromInts(key.codeUnits);
}
