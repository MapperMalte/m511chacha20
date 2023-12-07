import 'package:flutter_test/flutter_test.dart';
import 'package:m511chacha20/m_511.dart';
import 'package:m511chacha20/key_pair.dart';

void main() {
  test('A random BigInt has expected amount of bits +- 7', () {
    int bitdiff = KeyPair.randomBigInt(4096).bitLength - 4096;
    bitdiff = bitdiff < 0 ? -bitdiff : bitdiff;
    expect(bitdiff, lessThan(8));
  });

  test('Two random Big Ints are different', () {
    BigInt aliceSecret = KeyPair.randomBigInt(512);
    BigInt bobSecret = KeyPair.randomBigInt(512);

    expect(aliceSecret, isNot(bobSecret));
  });

  test('Alice and Bob have different public keys', () {
    BigInt aliceSecret = KeyPair.randomBigInt(512);
    BigInt bobSecret = KeyPair.randomBigInt(512);

    EllipticCurvePoint alicePublicKey =
        M511.multiply(M511.secureBasePoint, aliceSecret);
    EllipticCurvePoint bobPublicKey =
        M511.multiply(M511.secureBasePoint, bobSecret);

    expect(alicePublicKey.x, isNot(bobPublicKey.x));
    expect(alicePublicKey.y, isNot(bobPublicKey.y));
  });

  test('Alice and Bob compute the same secret', () {
    BigInt aliceSecret = KeyPair.randomBigInt(512);
    BigInt bobSecret = KeyPair.randomBigInt(512);

    EllipticCurvePoint alicePublicKey =
        M511.multiply(M511.secureBasePoint, aliceSecret);
    EllipticCurvePoint bobPublicKey =
        M511.multiply(M511.secureBasePoint, bobSecret);

    EllipticCurvePoint aliceComputesSharedSecret =
        M511.multiply(bobPublicKey, aliceSecret);
    EllipticCurvePoint bobComputesSharedSecret =
        M511.multiply(alicePublicKey, bobSecret);

    expect(aliceComputesSharedSecret.x, bobComputesSharedSecret.x);
  });
}
