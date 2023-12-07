import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:m511chacha20/cha_cha_20_algorithm.dart';

void main() {
  final Uint32List rfc7539232SampleState = Uint32List.fromList([
    0x61707865,
    0x3320646e,
    0x79622d32,
    0x6b206574,
    0x03020100,
    0x07060504,
    0x0b0a0908,
    0x0f0e0d0c,
    0x13121110,
    0x17161514,
    0x1b1a1918,
    0x1f1e1d1c,
    0x00000001,
    0x09000000,
    0x4a000000,
    0x00000000
  ]);

  final Uint32List
      rfc7539232SampleStateExpectedStateAfter20ChaChaQuarterRounds =
      Uint32List.fromList([
    0x837778ab,
    0xe238d763,
    0xa67ae21e,
    0x5950bb2f,
    0xc4f2d0c7,
    0xfc62bb2f,
    0x8fa018fc,
    0x3f5ec7b7,
    0x335271c2,
    0xf29489f3,
    0xeabda8fc,
    0x82e46ebd,
    0xd19c12b4,
    0xb04e16de,
    0x9e83d0cb,
    0x4e3c50a2
  ]);

  test('10 ChaCha20Algorithm Quarter Rounds give the 7539_232 sample state',
      () {
    {
      ChaCha20Algorithm chaCha20 =
          ChaCha20Algorithm.fromState(rfc7539232SampleState);
      chaCha20.tenQuarterRounds();
      expect(chaCha20.chaChaState,
          rfc7539232SampleStateExpectedStateAfter20ChaChaQuarterRounds);
    }
  });
}
