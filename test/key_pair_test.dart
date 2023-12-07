import 'package:flutter_test/flutter_test.dart';
import 'package:m511chacha20/key_pair.dart';

void main() {
  test('Alice and Bob compute the same shared key from a fresh key pair', () {
    KeyPair alice = KeyPair.fresh();
    KeyPair bob = KeyPair.fresh();

    BigInt aliceSharedSecret =
        KeyPair.computeSharedSecret(alice.privateKeyHex, bob.publicKeyHex);
    BigInt bobSharedSecret =
        KeyPair.computeSharedSecret(bob.privateKeyHex, alice.publicKeyHex);

    expect(aliceSharedSecret, bobSharedSecret);
  });
}
