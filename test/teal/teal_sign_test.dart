import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  test('test TEAL sign', () async {
    final data = base64Decode('Ux8jntyBJQarjKGF8A==');
    final seed = base64Decode('5Pf7eGMA52qfMT4R4/vYCt7con/7U3yejkdXkrcb26Q=');
    final program = TEALProgram(program: base64Decode('ASABASI='));
    final address = Address.fromAlgorandAddress(
      '6Z3C3LDVWGMX23BMSYMANACQOSINPFIRF77H7N3AWJZYV6OH6GWTJKVMXY',
    );
    final account = await Account.fromSeed(seed);
    final sig1 = await address.sign(account: account, data: data);
    final sig2 = await program.sign(account: account, data: data);
    expect(sig1, equals(sig2));

    final rawAddress = Uint8List.fromList(address.publicKey);

    // Prepend the prefix
    final progDataBytes = utf8.encode('ProgData');

    // Merge the byte arrays
    final buffer = Uint8List.fromList([
      ...progDataBytes,
      ...rawAddress,
      ...data,
    ]);

    final verified = await crypto.Ed25519().verify(
      buffer,
      signature: crypto.Signature(
        sig1.bytes,
        publicKey: account.address.toVerifyKey(),
      ),
    );

    expect(verified, isTrue);
  });
}
