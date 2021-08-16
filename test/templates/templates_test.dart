import 'dart:convert';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/templates/hash_time_lock_contract.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  test('test Var Int', () async {
    final a = 600000;
    final buffer = Logic.putUVarint(a);
    final result = Logic.getUVarint(buffer, 0);
    expect(result.value, equals(a));
    expect(result.length, equals(result.length));
  });

  test('test Hash Time Lock Contract', () async {
    final goldenAddress =
        'FBZIR3RWVT2BTGVOG25H3VAOLVD54RTCRNRLQCCJJO6SVSCT5IVDYKNCSU';
    final goldenProgram =
        'ASAE6AcBAMDPJCYDIOaalh5vLV96yGYHkmVSvpgjXtMzY8qIkYu5yTipFbb5IBB2YRNPIfx8AiI9UKues2ALw//DcSQjoeR7sfmp2/VfIP68oLsUSlpOp7Q4pGgayA5soQW8tgf8VlMlyVaV9qITMQEiDjEQIxIQMQcyAxIQMQgkEhAxCSgSLQEpEhAxCSoSMQIlDRAREA==';
    final goldenLtxn =
        'gqRsc2lngqNhcmeRxAhwcmVpbWFnZaFsxJcBIAToBwEAwM8kJgMg5pqWHm8tX3rIZgeSZVK+mCNe0zNjyoiRi7nJOKkVtvkgEHZhE08h/HwCIj1Qq56zYAvD/8NxJCOh5Hux+anb9V8g/ryguxRKWk6ntDikaBrIDmyhBby2B/xWUyXJVpX2ohMxASIOMRAjEhAxBzIDEhAxCCQSEDEJKBItASkSEDEJKhIxAiUNEBEQo3R4boelY2xvc2XEIOaalh5vLV96yGYHkmVSvpgjXtMzY8qIkYu5yTipFbb5o2ZlZc0D6KJmdgGiZ2jEIH+DsWV/8fxTuS3BgUih1l38LUsfo9Z3KErd0gASbZBpomx2ZKNzbmTEIChyiO42rPQZmq42un3UDl1H3kZii2K4CElLvSrIU+oqpHR5cGWjcGF5';

    // Create the contract
    final owner = Address.fromAlgorandAddress(
      address: '726KBOYUJJNE5J5UHCSGQGWIBZWKCBN4WYD7YVSTEXEVNFPWUIJ7TAEOPM',
    );
    final receiver = Address.fromAlgorandAddress(
      address: '42NJMHTPFVPXVSDGA6JGKUV6TARV5UZTMPFIREMLXHETRKIVW34QFSDFRE',
    );
    final hashFunction = HashFunction.SHA256;
    final hashImage = 'EHZhE08h/HwCIj1Qq56zYAvD/8NxJCOh5Hux+anb9V8=';

    final contract = HashTimeLockContract.create(
      owner: owner,
      receiver: receiver,
      hashFunction: hashFunction,
      hashImage: hashImage,
      expiryRound: 600000,
      maxFee: 1000,
    );

    expect(contract.address.encodedAddress, equals(goldenAddress));
    expect(base64Encode(contract.program), equals(goldenProgram));

    // Create transactions
    final preImageAsBase4 = 'cHJlaW1hZ2U=';
    final gh = 'f4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGk=';
    final signedTx = await HashTimeLockContract.getTransaction(
      contract: contract,
      preImage: preImageAsBase4,
      firstValid: 1,
      lastValid: 100,
      genesisHash: gh,
      feePerByte: 0,
    );

    expect(signedTx.toBase64(), equals(goldenLtxn));
  });
}
