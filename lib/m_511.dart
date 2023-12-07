import 'dart:core';

class EllipticCurvePoint {
  BigInt x;
  BigInt y;

  EllipticCurvePoint(this.x, this.y);
}

class M511 {
  static final BigInt unnecessarilyLargePrimeWithLowCofactor = BigInt.parse(
      "6703903964971298549787012499102923063739682910296196688861780721860882015036773488400937149083451713845015929093243025426876941405973284973216824503041861");

  /// A secure based point from a paper
  static final EllipticCurvePoint secureBasePoint = EllipticCurvePoint(
      BigInt.from(5),
      BigInt.parse(
          "2500410645565072423368981149139213252211568685173608590070979264248275228603899706950518127817176591878667784247582124505430745177116625808811349787373477"));
  static final BigInt A = BigInt.from(530438);
  static final BigInt three = BigInt.from(3);

  /// Multiplies an elliptic curve point with another number usind the efficient
  /// double and add scheme. NOTE: This is not secure against side-channel-attacks.
  /// If you need security against side-channel-attacks, change the if statement
  /// so that both clauses consume the same amount of CPU cycles and energy in any case.
  static EllipticCurvePoint multiply(
      EllipticCurvePoint ellipticCurvePoint, BigInt n) {
    BigInt doneAdditions = BigInt.zero;
    EllipticCurvePoint result = ellipticCurvePoint;
    while (doneAdditions < n) {
      if ((n - doneAdditions).isEven) {
        result = add(result, result);
        doneAdditions += ((n - doneAdditions) ~/ BigInt.two);
      } else {
        result = add(result, ellipticCurvePoint);
        doneAdditions += BigInt.one;
      }
    }
    return result;
  }

  /// Adds the elliptic curve points according to their group law and returns the result.
  static EllipticCurvePoint add(EllipticCurvePoint a, EllipticCurvePoint b) {
    BigInt lambda;
    if (a.x == b.x) {
      lambda = ((three * (a.x * a.x) + A) *
              (BigInt.two * a.y)
                  .modInverse(unnecessarilyLargePrimeWithLowCofactor)) %
          unnecessarilyLargePrimeWithLowCofactor;
    } else {
      lambda = ((b.y - a.y) *
              (b.x - a.x).modInverse(unnecessarilyLargePrimeWithLowCofactor)) %
          unnecessarilyLargePrimeWithLowCofactor;
    }
    BigInt xr =
        (lambda * lambda - a.x - b.x) % unnecessarilyLargePrimeWithLowCofactor;
    return EllipticCurvePoint(xr,
        (lambda * (a.x - xr) - a.y) % unnecessarilyLargePrimeWithLowCofactor);
  }
}
