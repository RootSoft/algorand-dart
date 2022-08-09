import 'package:algorand_dart/algorand_dart.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  test('Test encode decode str', () async {
    for (var i = 0; i < 1000; i++) {
      final b = generateRandomBytes();
      final address = Address(publicKey: b);
      final encodedAddress = address.encodedAddress;
      final address2 = Address.fromAlgorandAddress(encodedAddress);
      expect(address, equals(address2));
    }
  });

  test('Test golden values', () async {
    final golden = '7777777777777777777777777777777777777777777777777774MSJUVU';
    final b = fillBytes(0xFF);
    final address = Address(publicKey: b);
    expect(address.encodedAddress, equals(golden));
  });

  test('Test address for application', () async {
    final applicationId = 77;

    final actual = Address.forApplication(applicationId);
    final expected = Address.fromAlgorandAddress(
      'PCYUFPA2ZTOYWTP43MX2MOX2OWAIAXUDNC2WFCXAGMRUZ3DYD6BWFDL5YM',
    );
    expect(actual, equals(expected));
  });
}
