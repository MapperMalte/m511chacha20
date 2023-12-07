import 'dart:math';
import 'm_511.dart';

class KeyPair {
  /// This should be kept private to each user who generated a KeyPair
  late String privateKeyHex;

  /// This can be published
  late String publicKeyHex;

  /// Creates a random Big Integer with roughly bitLength amount of bits using a secure random generator.
  /// If you need EXACTLY bigLength amount of bits, you might need to
  /// pad the resulting BigInt
  static BigInt randomBigInt(int bitLength) {
    final random = Random.secure();
    final hexDigitCount =
        (bitLength / 4).ceil(); // Each hex digit represents 4 bits
    final buffer = StringBuffer();

    while (buffer.length < hexDigitCount) {
      buffer.write(random.nextInt(16).toRadixString(16));
    }

    // Add leading zeros if necessary to reach the desired bit length
    final hexString = buffer.toString().padLeft(hexDigitCount, '0');
    return BigInt.parse(hexString, radix: 16);
  }

  /// Creates a fresh private and public key for ECDH with 512 bits from a secure random algorithm.
  KeyPair.fresh() {
    BigInt secret = randomBigInt(512);

    EllipticCurvePoint publicKeyPoint =
        M511.multiply(M511.secureBasePoint, secret);

    privateKeyHex = secret.toRadixString(16);
    publicKeyHex =
        "${publicKeyPoint.x.toRadixString(16)}/${publicKeyPoint.y.toRadixString(16)}";
  }

  /// parses a serialized elliptic curve poimnt
  static EllipticCurvePoint parsePublicKey(String publicKey) {
    List<String> publicKeyTokens = publicKey.split("/");
    return EllipticCurvePoint(BigInt.parse(publicKeyTokens[0], radix: 16),
        BigInt.parse(publicKeyTokens[1], radix: 16));
  }

  /// Parses a Hex-String to a BigInt
  static BigInt parsePrivateKey(String privateKeyHex) {
    return BigInt.parse(privateKeyHex, radix: 16);
  }

  /// Computes the shared secret of Alice and Bob based on two Hexadecimal Strings
  static BigInt computeSharedSecret(String privateKeyHex, String publicKeyHex) {
    return M511
        .multiply(parsePublicKey(publicKeyHex), parsePrivateKey(privateKeyHex))
        .x;
  }
}
