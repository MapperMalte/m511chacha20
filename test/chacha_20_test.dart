import 'package:flutter_test/flutter_test.dart';
import 'package:m511chacha20/chacha20.dart';
import 'package:m511chacha20/chacha20_key.dart';
import 'package:m511chacha20/key_pair.dart';
import 'package:m511chacha20/nonce.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('Encrypts and decrypts Lorem Ipsum', () {
    ChaCha20 chaCha20 =
        ChaCha20(ChaCha20Key.fromBigInt(KeyPair.randomBigInt(512)));
    Nonce nonce = Nonce.fromUUID(const Uuid().v1());

    String plainText =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla id arcu purus. Pellentesque pharetra enim et nulla lobortis porttitor. Pellentesque tincidunt pharetra mauris, quis finibus orci pharetra ut. Vivamus laoreet sollicitudin erat nec vestibulum. Phasellus auctor malesuada nunc, sit amet elementum nunc dictum ac. Donec tempus laoreet est vel eleifend. Etiam at ipsum dapibus, vulputate magna in, rhoncus sem. Sed eu ornare purus. Fusce hendrerit ornare lacus sed viverra. Quisque maximus tincidunt dapibus. Aliquam tincidunt arcu ut lorem varius consectetur. Sed nec dui felis.";
    String cipher = chaCha20.encrypt(plainText, nonce);
    expect(cipher, isNot(plainText));
    expect(chaCha20.decrypt(cipher, nonce), plainText);
  });

  test('Encrypts and decrypts map', () {
    ChaCha20 chaCha20 =
        ChaCha20(ChaCha20Key.fromBigInt(KeyPair.randomBigInt(512)));
    Nonce nonce = Nonce.fromUUID(const Uuid().v1());
    Map<String, dynamic> data = {
      "a": 1,
      "b": "c",
      "d": true,
      "e": 3.1415926535897,
      "f": {
        "g": [
          "h",
          "i",
          {"j": "k"}
        ],
        "l": 4,
        "m": "nopqrst",
      },
      "u": ["v", "w", "x", "y", "z"]
    };
    expect(chaCha20.decryptMap(chaCha20.encryptMap(data, nonce), nonce), data);
  });
}
