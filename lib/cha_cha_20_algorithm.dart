import 'dart:typed_data';

class ChaCha20Algorithm {
  static List<int> magicConstants = [
    0x61707865,
    0x3320646e,
    0x79622d32,
    0x6b206574
  ];

  /// The current state of this ChaCha20 iteration.
  late Uint32List chaChaState;
  ChaCha20Algorithm.fromState(this.chaChaState);

  /// Expects a key with 8*32 bit, a 32-bit block-counter and a 3x32 bit nonce
  ChaCha20Algorithm(Uint32List key, int blockCounter, Uint32List nonce) {
    assert(key.length == 8);
    assert(nonce.length == 3);
    chaChaState = Uint32List.fromList([
      magicConstants[0],
      magicConstants[1],
      magicConstants[2],
      magicConstants[3],
      key[0],
      key[1],
      key[2],
      key[3],
      key[4],
      key[5],
      key[6],
      key[7],
      blockCounter,
      nonce[0],
      nonce[1],
      nonce[2]
    ]);
  }

  /// Returns a new Uint8List with transformed inputBytes.
  /// This can encrypt and decrypt, since they are the same for Chacha20.
  Uint8List processBytes(Uint8List inputBytes) {
    chaCha20();
    Uint8List outputBytes = Uint8List(inputBytes.length);
    Uint8List nextChaChaBytes = chaChaState.buffer.asUint8List();

    for (int j = 0; j < outputBytes.length; j++) {
      outputBytes[j] = inputBytes[j] ^ nextChaChaBytes[j % 64];

      if (j % 64 == 0) {
        chaCha20();
        nextChaChaBytes = chaChaState.buffer.asUint8List();
      }
    }

    return outputBytes;
  }

  /// Performs the ChaCha20 algorithm
  void chaCha20() {
    Uint32List initialStateCopy = Uint32List.fromList(chaChaState.toList());
    tenQuarterRounds();

    for (int i = 0; i < chaChaState.length; i++) {
      chaChaState[i] += initialStateCopy[i];
    }
  }

  /// implementation of a left rotation of an integer by count places.
  int rotateLeft(int n, int count) {
    assert(count >= 0 && count < 32);
    if (count == 0) return n;
    return (n << count) |
        ((n >= 0) ? n >> (32 - count) : ~(~n >> (32 - count)));
  }

  /// ChaCha20 consists of ten of these quarter rounds
  void tenQuarterRounds() {
    for (int i = 0; i < 10; i++) {
      quarterRound(0, 4, 8, 12);
      quarterRound(1, 5, 9, 13);
      quarterRound(2, 6, 10, 14);
      quarterRound(3, 7, 11, 15);
      quarterRound(0, 5, 10, 15);
      quarterRound(1, 6, 11, 12);
      quarterRound(2, 7, 8, 13);
      quarterRound(3, 4, 9, 14);
    }
  }

  /// Takes a list of four inputs and performs a ChaCha quarter round on them
  Uint32List transformFourInputsByChaChaQuarterRound(Uint32List fourInputs) {
    fourInputs[0] += fourInputs[1];
    fourInputs[3] ^= fourInputs[0];
    fourInputs[3] = rotateLeft(fourInputs[3], 16);

    fourInputs[2] += fourInputs[3];
    fourInputs[1] ^= fourInputs[2];
    fourInputs[1] = rotateLeft(fourInputs[1], 12);

    fourInputs[0] += fourInputs[1];
    fourInputs[3] ^= fourInputs[0];
    fourInputs[3] = rotateLeft(fourInputs[3], 8);

    fourInputs[2] += fourInputs[3];
    fourInputs[1] ^= fourInputs[2];
    fourInputs[1] = rotateLeft(fourInputs[1], 7);

    return fourInputs;
  }

  /// Performs a quarter round of ChaCha20 according to the documentation by RFC
  void quarterRound(int a, int b, int c, int d) {
    Uint32List result = transformFourInputsByChaChaQuarterRound(
        Uint32List.fromList(
            [chaChaState[a], chaChaState[b], chaChaState[c], chaChaState[d]]));
    chaChaState[a] = result[0];
    chaChaState[b] = result[1];
    chaChaState[c] = result[2];
    chaChaState[d] = result[3];
  }
}
