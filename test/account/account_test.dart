import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/mnemonic/mnemonic.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  test('Test sign transaction E2E', () async {
    final refSigTxn =
        // ignore: lines_longer_than_80_chars
        '82a3736967c4403f5a5cbc5cb038b0d29a53c0adf8a643822da0e41681bcab050e406fd40af20aa56a2f8c0e05d3bee8d4e8489ef13438151911b31b5ed5b660cac6bae4080507a374786e87a3616d74cd04d2a3666565cd03e8a26676ce0001a04fa26c76ce0001a437a3726376c4207d3f99e53d34ae49eb2f458761cf538408ffdaee35c70d8234166de7abe3e517a3736e64c4201bd63dc672b0bb29d42fcafa3422a4d385c0c8169bb01595babf8855cf596979a474797065a3706179';
    final refTxId = 'BXSNCHKYEXB4AQXFRROUJGZ4ZWD7WL2F5D27YUPFR7ONDK5TMN5Q';
    final fromAddress =
        'DPLD3RTSWC5STVBPZL5DIIVE2OC4BSAWTOYBLFN2X6EFLT2ZNF4SMX64UA';
    final mnemonic =
        // ignore: lines_longer_than_80_chars
        'actress tongue harbor tray suspect odor load topple vocal avoid ignore apple lunch unknown tissue museum once switch captain place lemon sail outdoor absent creek';

    final sender = Address.fromAlgorandAddress(fromAddress);
    final receiver = Address.fromAlgorandAddress(
      'PU7ZTZJ5GSXET2ZPIWDWDT2TQQEP7WXOGXDQ3ARUCZW6PK7D4ULSE6NYCE',
    );

    final tx = await (PaymentTransactionBuilder()
          ..sender = sender
          ..receiver = receiver
          ..flatFee = BigInt.from(1000)
          ..amount = BigInt.from(1234)
          ..firstValid = BigInt.from(106575)
          ..lastValid = BigInt.from(107575))
        .build();

    final account = await Account.fromSeedPhrase(mnemonic.split(' '));
    expect(account.publicAddress, equals(fromAddress));

    // Sign transaction
    final signedTx = await tx.sign(account);
    final signedBytes = Encoder.encodeMessagePack(signedTx.toMessagePack());
    final signedHex = hex.encode(signedBytes);

    expect(signedHex, equals(refSigTxn));

    final txId = signedTx.transaction.id;
    expect(txId, equals(refTxId));
  });

  test('Test keygen', () async {
    for (var i = 0; i < 100; i++) {
      final account = await Account.random();
      expect(account.publicKey.bytes, isNotEmpty);
      expect(account.address, isNotNull);
      expect(account.publicKey.bytes, equals(account.address.publicKey));
    }
  });

  test('Test to mnemonic', () async {
    final from =
        // ignore: lines_longer_than_80_chars
        'actress tongue harbor tray suspect odor load topple vocal avoid ignore apple lunch unknown tissue museum once switch captain place lemon sail outdoor absent creek';
    final account = await Account.fromSeedPhrase(from.split(' '));
    final seedphrase = await account.seedPhrase;
    expect(seedphrase.join(' '), equals(from));
  });

  test('Test sign msig transaction', () async {
    final msa = createTestMsigAddress();

    // Create unsigned tx
    final tx = await (PaymentTransactionBuilder()
          ..sender = msa.toAddress()
          ..receiver = Address.fromAlgorandAddress(
            'DN7MBMCL5JQ3PFUQS7TMX5AH4EEKOBJVDUF4TCV6WERATKFLQF4MQUPZTA',
          )
          ..flatFee = BigInt.from(217000)
          ..firstValid = BigInt.from(972508)
          ..lastValid = BigInt.from(973508)
          ..noteB64 = 'tFF5Ofz60nE='
          ..genesisId = 'testnet-v31.0'
          ..amount = BigInt.from(5000))
        .build();

    final goldenTxId = 'KY6I7NQXQDAMDUCAVATI45BAODW6NRYQKFH4KIHLH2HQI4DO4XBA';
    expect(tx.id, equals(goldenTxId));

    final words =
        // ignore: lines_longer_than_80_chars
        'auction inquiry lava second expand liberty glass involve ginger illness length room item discover ahead table doctor term tackle cement bonus profit right above catch';

    final account = await Account.fromSeedPhrase(words.split(' '));
    final stx = await msa.sign(account: account, transaction: tx);

    final txBytes = Encoder.encodeMessagePack(stx.toMessagePack());
    final golden =
        'gqRtc2lng6ZzdWJzaWeTgqJwa8QgG37AsEvqYbeWkJfmy/QH4QinBTUdC8mKvrEiCairgXihc8RAdvZ3y9GsInBPutdwKc7Jy+an13CcjSV1lcvRAYQKYOxXwfgT5B/mK14R57ueYJTYyoDO8zBY6kQmBalWkm95AIGicGvEIAljMglTc4nwdWcRdzmRx9A+G3PIxPUr9q/wGqJc+cJxgaJwa8Qg5/D4TQaBHfnzHI2HixFV9GcdUaGFwgCQhmf0SVhwaKGjdGhyAqF2AaN0eG6Jo2FtdM0TiKNmZWXOAANPqKJmds4ADtbco2dlbq10ZXN0bmV0LXYzMS4womx2zgAO2sSkbm90ZcQItFF5Ofz60nGjcmN2xCAbfsCwS+pht5aQl+bL9AfhCKcFNR0LyYq+sSIJqKuBeKNzbmTEII2StImQAXOgTfpDWaNmamr86ixCoF3Zwfc+66VHgDfppHR5cGWjcGF5';
    expect(txBytes, base64Decode(golden));
  });

  test('Test sign bytes', () async {
    final random = Random();
    final values =
        Uint8List.fromList(List<int>.generate(15, (i) => random.nextInt(256)));
    final account = await Account.random();
    final signature = await account.signBytes(values);
    final verified = await account.address.verify(values, signature);
    expect(verified, isTrue);

    var firstByte = values[0];
    firstByte = (firstByte + 1) % 256;
    values[0] = firstByte;

    final verified2 = await account.address.verify(values, signature);
    expect(verified2, isFalse);
  });

  test('Test verify bytes', () async {
    final message = base64Decode('rTs7+dUj');
    final signature = Signature(
      bytes: base64Decode(
        'COEBmoD+ysVECoyVOAsvMAjFxvKeQVkYld+RSHMnEiHsypqrfj2EdYqhrm4t7dK3ZOeSQh3aXiZK/zqQDTPBBw==',
      ),
    );

    final address = Address.fromAlgorandAddress(
      'DPLD3RTSWC5STVBPZL5DIIVE2OC4BSAWTOYBLFN2X6EFLT2ZNF4SMX64UA',
    );

    final verified = await address.verify(message, signature);
    expect(verified, isTrue);

    var firstByte = message[0];
    firstByte = (firstByte + 1) % 256;
    message[0] = firstByte;

    final verified2 = await address.verify(message, signature);
    expect(verified2, isFalse);
  });

  test('Test logic sig transaction', () async {
    final from = Address.fromAlgorandAddress(
      '47YPQTIGQEO7T4Y4RWDYWEKV6RTR2UNBQXBABEEGM72ESWDQNCQ52OPASU',
    );

    final to = Address.fromAlgorandAddress(
      'PNWOET7LLOWMBMLE4KOCELCX6X3D3Q4H2Q4QJASYIEOF7YIPPQBG3YQ5YI',
    );

    final mnemonic =
        // ignore: lines_longer_than_80_chars
        'advice pudding treat near rule blouse same whisper inner electric quit surface sunny dismiss leader blood seat clown cost exist hospital century reform able sponsor';
    final account = await Account.fromSeedPhrase(mnemonic.split(' '));

    final tx = await (PaymentTransactionBuilder()
          ..sender = from
          ..flatFee = BigInt.from(1000)
          ..firstValid = BigInt.from(2063137)
          ..lastValid = BigInt.from(2063137 + 1000)
          ..noteB64 = '8xMCTuLQ810='
          ..genesisId = 'devnet-v1.0'
          ..genesisHashB64 = 'sC3P7e2SdbqKJK0tbiCdK9tdSpbe6XeCGKdoNzmlj0E='
          ..amount = BigInt.from(2000)
          ..receiver = to)
        .build();

    final goldenTx =
        'gqRsc2lng6NhcmeSxAMxMjPEAzQ1NqFsxAUBIAEBIqNzaWfEQE6HXaI5K0lcq50o/y3bWOYsyw9TLi/oorZB4xaNdn1Z14351u2f6JTON478fl+JhIP4HNRRAIh/I8EWXBPpJQ2jdHhuiqNhbXTNB9CjZmVlzQPoomZ2zgAfeyGjZ2Vuq2Rldm5ldC12MS4womdoxCCwLc/t7ZJ1uookrS1uIJ0r211Klt7pd4IYp2g3OaWPQaJsds4AH38JpG5vdGXECPMTAk7i0PNdo3JjdsQge2ziT+tbrMCxZOKcIixX9fY9w4fUOQSCWEEcX+EPfAKjc25kxCDn8PhNBoEd+fMcjYeLEVX0Zx1RoYXCAJCGZ/RJWHBooaR0eXBlo3BheQ==';

    final program = Uint8List.fromList([0x01, 0x20, 0x01, 0x01, 0x22]);
    final args = <Uint8List>[];
    args.add(Uint8List.fromList([49, 50, 51]));
    args.add(Uint8List.fromList([52, 53, 54]));

    var lsig = LogicSignature(logic: program, arguments: args);
    lsig = await lsig.sign(account: account);
    final signedTx = await lsig.signTransaction(transaction: tx);
    final signedTxBytes = Encoder.encodeMessagePack(signedTx.toMessagePack());
    expect(base64Encode(signedTxBytes), equals(goldenTx));
  });

  test('Test TEAL sign', () async {
    final data = base64Decode('Ux8jntyBJQarjKGF8A==');
    final seed = base64Decode('5Pf7eGMA52qfMT4R4/vYCt7con/7U3yejkdXkrcb26Q=');
    final program = TEALProgram(program: base64Decode('ASABASI='));
    final address = Address.fromAlgorandAddress(
        '6Z3C3LDVWGMX23BMSYMANACQOSINPFIRF77H7N3AWJZYV6OH6GWTJKVMXY');
    final account = await Account.fromSeed(seed);

    final signature1 = await address.sign(account: account, data: data);
    final signature2 = await program.sign(account: account, data: data);
    expect(signature1, equals(signature2));

    // Verify data
    final progDataBytes = utf8.encode('ProgData');

    // Merge the byte arrays
    final buffer = Uint8List.fromList([
      ...progDataBytes,
      ...address.publicKey,
      ...data,
    ]);

    final verified = await crypto.Ed25519().verify(
      buffer,
      signature: crypto.Signature(
        signature1.bytes,
        publicKey: account.address.toVerifyKey(),
      ),
    );

    expect(verified, isTrue);
  });

  test('Test to seed', () async {
    final mnemonic =
        // ignore: lines_longer_than_80_chars
        'actress tongue harbor tray suspect odor load topple vocal avoid ignore apple lunch unknown tissue museum once switch captain place lemon sail outdoor absent creek';
    final seed = await Mnemonic.seed(mnemonic.split(' '));
    final account = await Account.fromSeed(seed);
    final seedphrase = await account.seedPhrase;
    expect(seedphrase, equals(mnemonic.split(' ')));
  });
}

MultiSigAddress createTestMsigAddress() {
  final one = Address.fromAlgorandAddress(
    'DN7MBMCL5JQ3PFUQS7TMX5AH4EEKOBJVDUF4TCV6WERATKFLQF4MQUPZTA',
  );
  final two = Address.fromAlgorandAddress(
    'BFRTECKTOOE7A5LHCF3TTEOH2A7BW46IYT2SX5VP6ANKEXHZYJY77SJTVM',
  );
  final three = Address.fromAlgorandAddress(
    '47YPQTIGQEO7T4Y4RWDYWEKV6RTR2UNBQXBABEEGM72ESWDQNCQ52OPASU',
  );

  return MultiSigAddress(
    version: 1,
    threshold: 2,
    publicKeys: [one, two, three],
  );
}
