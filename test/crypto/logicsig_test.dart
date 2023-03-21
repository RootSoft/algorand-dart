import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  test('Test logic sig creation', () async {
    final program = Uint8List.fromList(<int>[0x01, 0x20, 0x01, 0x01, 0x22]);
    final programHash =
        '6Z3C3LDVWGMX23BMSYMANACQOSINPFIRF77H7N3AWJZYV6OH6GWTJKVMXY';
    final sender = Address.fromAlgorandAddress(programHash);
    final lsig = LogicSignature(logic: program);
    expect(lsig.logic, program);
    expect(lsig.arguments, null);
    expect(lsig.signature, null);
    expect(lsig.multiSignature, null);
    final verified = await lsig.verify(sender);
    expect(verified, true);
    expect(lsig.toAddress(), sender);
  });

  test('Test logicsig invalid program', () async {
    final program = Uint8List.fromList(<int>[0x07, 0x20, 0x01, 0x01, 0x22]);
    expect(
      () => LogicSignature(logic: program),
      throwsA((e) => e is AlgorandException),
    );
  });

  test('Test logic signature', () async {
    final program = Uint8List.fromList(<int>[0x01, 0x20, 0x01, 0x01, 0x22]);
    var lsig = LogicSignature(logic: program);
    final account = await Account.random();
    lsig = await lsig.sign(account: account);

    expect(lsig.logic, equals(program));
    expect(lsig.arguments, isNull);
    expect(lsig.signature, isNotNull);
    expect(lsig.multiSignature, isNull);

    final verified = await lsig.verify(account.address);
    expect(verified, isTrue);
  });

  test('Test logicsig multisignature', () async {
    final program = Uint8List.fromList(<int>[0x01, 0x20, 0x01, 0x01, 0x22]);
    final one = Address.fromAlgorandAddress(
        'DN7MBMCL5JQ3PFUQS7TMX5AH4EEKOBJVDUF4TCV6WERATKFLQF4MQUPZTA');
    final two = Address.fromAlgorandAddress(
        'BFRTECKTOOE7A5LHCF3TTEOH2A7BW46IYT2SX5VP6ANKEXHZYJY77SJTVM');
    final three = Address.fromAlgorandAddress(
        '47YPQTIGQEO7T4Y4RWDYWEKV6RTR2UNBQXBABEEGM72ESWDQNCQ52OPASU');

    final publicKeys = [one, two, three];

    final msa =
        MultiSigAddress(version: 1, threshold: 2, publicKeys: publicKeys);

    final mn1 =
        // ignore: lines_longer_than_80_chars
        'auction inquiry lava second expand liberty glass involve ginger illness length room item discover ahead table doctor term tackle cement bonus profit right above catch';
    final mn2 =
        // ignore: lines_longer_than_80_chars
        'since during average anxiety protect cherry club long lawsuit loan expand embark forum theory winter park twenty ball kangaroo cram burst board host ability left';
    final account1 = await Account.fromSeedPhrase(mn1.split(' '));
    final account2 = await Account.fromSeedPhrase(mn2.split(' '));
    final account = await Account.random();

    var lsig = LogicSignature(logic: program);
    lsig = await lsig.sign(account: account1, multiSigAddress: msa);
    expect(lsig.logic, program);
    expect(lsig.arguments, isNull);
    expect(lsig.signature, isNull);
    expect(lsig.multiSignature, isNotNull);

    var verified = await lsig.verify(msa.toAddress());
    expect(verified, isFalse);
    lsig = await lsig.append(account: account2);
    verified = await lsig.verify(msa.toAddress());
    expect(verified, isTrue);

    // Add a single signature and ensure it fails
    var lsig1 = LogicSignature(logic: program);
    lsig1 = await lsig1.sign(account: account);
    lsig = lsig.copyWith(signature: lsig1.signature);
    verified = await lsig.verify(msa.toAddress());
    expect(verified, isFalse);
    verified = await lsig.verify(account.address);
    expect(verified, isFalse);
  });
}
