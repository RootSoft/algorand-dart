import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:test/test.dart';

void main() {
  late Account account;

  setUp(() async {
    final words =
        // ignore: lines_longer_than_80_chars
        'awful drop leaf tennis indoor begin mandate discover uncle seven only coil atom any hospital uncover make any climb actor armed measure need above hundred';
    account = await Account.fromSeedPhrase(words.split(' '));
  });

  void expectEqualTransaction(RawTransaction actual, RawTransaction expected) {
    expect(actual, equals(expected));
    expect(actual.sender, equals(expected.sender));
    expect(actual.lastValid, equals(expected.lastValid));
    expect(actual.genesisHash, equals(expected.genesisHash));

    if (actual is PaymentTransaction && expected is PaymentTransaction) {
      expect(actual.receiver, equals(expected.receiver));
      expect(actual.amount, equals(expected.amount));
    }
  }

  PaymentTransaction getDecodedPaymentTransaction(RawTransaction transaction) {
    final encodedBytes = Encoder.encodeMessagePack(transaction.toMessagePack());
    return PaymentTransaction.fromJson(Encoder.decodeMessagePack(encodedBytes));
  }

  Future<SignedTransaction> expectAssetCreation(
    int decimals,
    String golden,
  ) async {
    final address = Address.fromAlgorandAddress(
      'BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4',
    );

    final url = List<String>.filled(96, 'w').join();
    final metaDataHash = 'fACPO4nRgO55j1ndAK3W6Sgc4APkcyFh';
    final tx = await (AssetConfigTransactionBuilder()
          ..sender = address
          ..suggestedFeePerByte = BigInt.from(10)
          ..firstValid = BigInt.from(322575)
          ..lastValid = BigInt.from(323575)
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI='
          ..totalAssetsToCreate = BigInt.from(100)
          ..decimals = decimals
          ..unitName = 'tst'
          ..assetName = 'testcoin'
          ..url = url
          ..metadataText = metaDataHash
          ..managerAddress = address
          ..reserveAddress = address
          ..freezeAddress = address
          ..clawbackAddress = address)
        .build();

    return await tx.sign(account);
  }

  test('Test serialization msgpack', () async {
    final sender = Address.fromAlgorandAddress(
      'VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ',
    );

    final receiver = Address.fromAlgorandAddress(
      'VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ',
    );

    final tx = await (PaymentTransactionBuilder()
          ..sender = sender
          ..receiver = receiver
          ..amount = BigInt.from(100)
          ..firstValid = BigInt.from(301)
          ..lastValid = BigInt.from(1300))
        .build();

    final b = Encoder.encodeMessagePack(tx.toMessagePack());
    final o = Encoder.decodeMessagePack(b);
    final otx = PaymentTransaction.fromJson(o);

    expectEqualTransaction(tx, otx);
  });

  test('Test serialization msgpack uint64', () async {
    final sender = Address.fromAlgorandAddress(
      'VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ',
    );

    final receiver = Address.fromAlgorandAddress(
      'VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ',
    );

    final tx = await (PaymentTransactionBuilder()
          ..sender = sender
          ..receiver = receiver
          ..amount = BigIntEncoder.MAX_UINT64 - BigInt.one
          ..firstValid = BigInt.from(301)
          ..lastValid = BigInt.from(1300))
        .build();

    final b = Encoder.encodeMessagePack(tx.toMessagePack());
    final o = Encoder.decodeMessagePack(b);
    final otx = PaymentTransaction.fromJson(o);

    expectEqualTransaction(tx, otx);
  });

  test('Test payment transaction', () async {});

  test('Test create asset', () async {
    final golden =
        'gqNzaWfEQF2hf4SoXzT2Wyp5p3CYbMoX2xmrRrKfxxqSa8uhSXv+qDpAIdvFVlQhkNXpz8j7m7M/9xjPBSXSUxnYuzbgvQijdHhuh6RhcGFyiaJhbcQgZkFDUE80blJnTzU1ajFuZEFLM1c2U2djNEFQa2N5RmiiYW6odGVzdGNvaW6iYXXZYHd3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d6FjxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aFmxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aFtxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aFyxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aF0ZKJ1bqN0c3SjZmVlzRM4omZ2zgAE7A+iZ2jEIEhjtRiks8hOyBDyLU8QgcsPcfBZp6wg3sYvf3DlCToiomx2zgAE7/ejc25kxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aR0eXBlpGFjZmc=';
    final signedTx = await expectAssetCreation(0, golden);

    final encoded = Encoder.encodeMessagePack(signedTx.toMessagePack());
    final decoded = Encoder.decodeMessagePack(encoded);
    final decodedTx = SignedTransaction.fromJson(decoded);
    expect(decodedTx, equals(signedTx));
    expect(base64Encode(encoded), equals(golden));
  });

  test('Test create asset with decimals', () async {
    final golden =
        'gqNzaWfEQGMrl8xmewPhzZL2aLc7Wt+ZI8Ff1HXxA+xO11kbChe/tPIC5scCHv6M+cgTLl1nG9Z0406ScpoeNoIDpcLPXgujdHhuh6RhcGFyiqJhbcQgZkFDUE80blJnTzU1ajFuZEFLM1c2U2djNEFQa2N5RmiiYW6odGVzdGNvaW6iYXXZYHd3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d6FjxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aJkYwGhZsQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2hbcQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2hcsQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2hdGSidW6jdHN0o2ZlZc0TYKJmds4ABOwPomdoxCBIY7UYpLPITsgQ8i1PEIHLD3HwWaesIN7GL39w5Qk6IqJsds4ABO/3o3NuZMQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2kdHlwZaRhY2Zn';
    final signedTx = await expectAssetCreation(1, golden);

    final encoded = Encoder.encodeMessagePack(signedTx.toMessagePack());
    final decoded = Encoder.decodeMessagePack(encoded);
    final decodedTx = SignedTransaction.fromJson(decoded);
    expect(decodedTx, equals(signedTx));
    expect(base64Encode(encoded), equals(golden));
  });

  test('Test asset transfer', () async {
    final golden =
        'gqNzaWfEQNkEs3WdfFq6IQKJdF1n0/hbV9waLsvojy9pM1T4fvwfMNdjGQDy+LeesuQUfQVTneJD4VfMP7zKx4OUlItbrwSjdHhuiqRhYW10AaZhY2xvc2XEIAn70nYsCPhsWua/bdenqQHeZnXXUOB+jFx2mGR9tuH9pGFyY3bEIAn70nYsCPhsWua/bdenqQHeZnXXUOB+jFx2mGR9tuH9o2ZlZc0KvqJmds4ABOwPomdoxCBIY7UYpLPITsgQ8i1PEIHLD3HwWaesIN7GL39w5Qk6IqJsds4ABO/4o3NuZMQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2kdHlwZaVheGZlcqR4YWlkAQ==';
    final address = Address.fromAlgorandAddress(
      'BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4',
    );

    final tx = await (AssetTransferTransactionBuilder()
          ..sender = address
          ..receiver = address
          ..closeTo = address
          ..amount = BigInt.from(1)
          ..flatFee = BigInt.from(10)
          ..firstValid = BigInt.from(322575)
          ..lastValid = BigInt.from(323576)
          ..assetId = 1
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI=')
        .build();

    await tx.setFeeByFeePerByte(BigInt.from(10));
    final encodedBytes = Encoder.encodeMessagePack(tx.toMessagePack());
    final o = AssetTransferTransaction.fromJson(
        Encoder.decodeMessagePack(encodedBytes));

    expect(tx, equals(o));

    final signedTx = await tx.sign(account);
    final signedBytes = Encoder.encodeMessagePack(signedTx.toMessagePack());
    final stxDecoded =
        SignedTransaction.fromJson(Encoder.decodeMessagePack(signedBytes));

    expect(signedTx.toMessagePack(), equals(stxDecoded.toMessagePack()));
    expect(signedTx, equals(stxDecoded));
    expect(base64Encode(signedBytes), equals(golden));
  });

  test('Test asset revocation', () async {
    final golden =
        'gqNzaWfEQHsgfEAmEHUxLLLR9s+Y/yq5WeoGo/jAArCbany+7ZYwExMySzAhmV7M7S8+LBtJalB4EhzEUMKmt3kNKk6+vAWjdHhuiqRhYW10AaRhcmN2xCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aRhc25kxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aNmZWXNCqqiZnbOAATsD6JnaMQgSGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiKibHbOAATv96NzbmTEIAn70nYsCPhsWua/bdenqQHeZnXXUOB+jFx2mGR9tuH9pHR5cGWlYXhmZXKkeGFpZAE=';
    final address = Address.fromAlgorandAddress(
      'BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4',
    );

    final tx = await (AssetTransferTransactionBuilder()
          ..sender = address
          ..assetSender = address
          ..receiver = address
          ..amount = BigInt.one
          ..flatFee = BigInt.from(10)
          ..firstValid = BigInt.from(322575)
          ..lastValid = BigInt.from(323575)
          ..assetId = 1
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI=')
        .build();

    await tx.setFeeByFeePerByte(BigInt.from(10));
    final encodedBytes = Encoder.encodeMessagePack(tx.toMessagePack());
    final o = AssetTransferTransaction.fromJson(
        Encoder.decodeMessagePack(encodedBytes));

    expect(tx, equals(o));

    final signedTx = await tx.sign(account);
    final signedBytes = Encoder.encodeMessagePack(signedTx.toMessagePack());
    final stxDecoded =
        SignedTransaction.fromJson(Encoder.decodeMessagePack(signedBytes));

    expect(signedTx.toMessagePack(), equals(stxDecoded.toMessagePack()));
    expect(signedTx, equals(stxDecoded));

    // Test golden
    final goldenTx = SignedTransaction.fromJson(
        Encoder.decodeMessagePack(base64Decode(golden)));
    expect(signedTx.transaction.toMessagePack(),
        equals(goldenTx.transaction.toMessagePack()));
    expect(base64Encode(signedBytes), equals(golden));
  });

  test('Test asset freeze', () async {
    final golden =
        'gqNzaWfEQAhru5V2Xvr19s4pGnI0aslqwY4lA2skzpYtDTAN9DKSH5+qsfQQhm4oq+9VHVj7e1rQC49S28vQZmzDTVnYDQGjdHhuiaRhZnJ6w6RmYWRkxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aRmYWlkAaNmZWXNCRqiZnbOAATsD6JnaMQgSGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiKibHbOAATv+KNzbmTEIAn70nYsCPhsWua/bdenqQHeZnXXUOB+jFx2mGR9tuH9pHR5cGWkYWZyeg==';
    final address = Address.fromAlgorandAddress(
      'BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4',
    );

    final tx = await (AssetFreezeTransactionBuilder()
          ..sender = address
          ..freezeTarget = address
          ..freeze = true
          ..flatFee = BigInt.from(10)
          ..firstValid = BigInt.from(322575)
          ..lastValid = BigInt.from(323576)
          ..assetId = 1
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI=')
        .build();

    await tx.setFeeByFeePerByte(BigInt.from(10));
    final encodedBytes = Encoder.encodeMessagePack(tx.toMessagePack());
    final o = AssetFreezeTransaction.fromJson(
        Encoder.decodeMessagePack(encodedBytes));

    expect(tx, equals(o));

    final signedTx = await tx.sign(account);
    final signedBytes = Encoder.encodeMessagePack(signedTx.toMessagePack());
    final stxDecoded =
        SignedTransaction.fromJson(Encoder.decodeMessagePack(signedBytes));

    expect(signedTx.toMessagePack(), equals(stxDecoded.toMessagePack()));
    expect(signedTx, equals(stxDecoded));

    // Test golden
    final goldenTx = SignedTransaction.fromJson(
        Encoder.decodeMessagePack(base64Decode(golden)));
    expect(signedTx.transaction.toMessagePack(),
        equals(goldenTx.transaction.toMessagePack()));
    expect(base64Encode(signedBytes), equals(golden));
  });

  test('Test key reg transaction', () async {
    final address = Address.fromAlgorandAddress(
      'BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4',
    );

    final tx = await (KeyRegistrationTransactionBuilder()
          ..sender = address
          ..votePK = ParticipationPublicKey(bytes: generateRandomBytes())
          ..selectionPK = VRFPublicKey(bytes: generateRandomBytes())
          ..stateProofPublicKey =
              MerkleSignatureVerifier(bytes: generateRandomBytes(null, 64))
          ..voteFirst = 322575
          ..voteLast = 323576
          ..voteKeyDilution = 10000
          ..flatFee = BigInt.from(10)
          ..firstValid = BigInt.from(322575)
          ..lastValid = BigInt.from(323576)
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI=')
        .build();

    await tx.setFeeByFeePerByte(BigInt.from(10));
    final encodedBytes = Encoder.encodeMessagePack(tx.toMessagePack());
    final o = KeyRegistrationTransaction.fromJson(
        Encoder.decodeMessagePack(encodedBytes));

    expect(tx, equals(o));

    final signedTx = await tx.sign(account);
    final signedBytes = Encoder.encodeMessagePack(signedTx.toMessagePack());
    final stxDecoded =
        SignedTransaction.fromJson(Encoder.decodeMessagePack(signedBytes));

    expect(signedTx.toMessagePack(), equals(stxDecoded.toMessagePack()));
    expect(signedTx, equals(stxDecoded));
  });

  test('Test logic sign', () async {
    final golden =
        'gqRsc2lngaFsxAUBIAEBIqN0eG6Io2FtdGSjZmVlzQiYomZ2zQEtomdoxCBIY7UYpLPITsgQ8i1PEIHLD3HwWaesIN7GL39w5Qk6IqJsds0FFKNyY3bEIAn70nYsCPhsWua/bdenqQHeZnXXUOB+jFx2mGR9tuH9o3NuZMQg9nYtrHWxmX1sLJYYBoBQdJDXlREv/n+3YLJzivnH8a2kdHlwZaNwYXk=';
    final program = Uint8List.fromList(<int>[0x01, 0x20, 0x01, 0x01, 0x22]);
    var lsig = LogicSignature(logic: program);

    final address = Address.fromAlgorandAddress(
      'BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4',
    );

    final tx = await (PaymentTransactionBuilder()
          ..sender = lsig.toAddress()
          ..receiver = address
          ..amount = BigInt.from(100)
          ..firstValid = BigInt.from(301)
          ..lastValid = BigInt.from(1300)
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI=')
        .build();

    await tx.setFeeByFeePerByte(BigInt.from(10));
    final b = Encoder.encodeMessagePack(tx.toMessagePack());
    final o = Encoder.decodeMessagePack(b);
    final otx = PaymentTransaction.fromJson(o);

    expectEqualTransaction(tx, otx);

    // Sign the logic transaction
    final signedTx = await lsig.signTransaction(transaction: tx);
    final signedBytes = Encoder.encodeMessagePack(signedTx.toMessagePack());
    final stxO =
        SignedTransaction.fromJson(Encoder.decodeMessagePack(signedBytes));

    expect(signedTx.toMessagePack(), equals(stxO.toMessagePack()));
    expect(signedTx, equals(stxO));

    // Test golden
    final goldenTx = SignedTransaction.fromJson(
        Encoder.decodeMessagePack(base64Decode(golden)));
    expect(signedTx.transaction.toMessagePack(),
        equals(goldenTx.transaction.toMessagePack()));
    expect(base64Encode(signedBytes), equals(golden));
  });

  test('Test logic sign transaction with arguments', () async {
    final golden =
        'gqRsc2lngqNhcmeRxAF7oWzEBQEgAQEio3R4boijYW10ZKNmZWXNCJiiZnbNAS2iZ2jEIEhjtRiks8hOyBDyLU8QgcsPcfBZp6wg3sYvf3DlCToiomx2zQUUo3JjdsQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2jc25kxCD2di2sdbGZfWwslhgGgFB0kNeVES/+f7dgsnOK+cfxraR0eXBlo3BheQ==';
    final program = Uint8List.fromList(<int>[0x01, 0x20, 0x01, 0x01, 0x22]);
    final arguments = <Uint8List>[];
    arguments.add(Uint8List.fromList([123]));
    var lsig = LogicSignature(logic: program, arguments: arguments);

    final address = Address.fromAlgorandAddress(
      'BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4',
    );

    final tx = await (PaymentTransactionBuilder()
          ..sender = lsig.toAddress()
          ..receiver = address
          ..amount = BigInt.from(100)
          ..firstValid = BigInt.from(301)
          ..lastValid = BigInt.from(1300)
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI=')
        .build();

    await tx.setFeeByFeePerByte(BigInt.from(10));
    final b = Encoder.encodeMessagePack(tx.toMessagePack());
    final o = Encoder.decodeMessagePack(b);
    final otx = PaymentTransaction.fromJson(o);

    expectEqualTransaction(tx, otx);

    // Sign the logic transaction
    final signedTx = await lsig.signTransaction(transaction: tx);
    final signedBytes = Encoder.encodeMessagePack(signedTx.toMessagePack());
    final stxO =
        SignedTransaction.fromJson(Encoder.decodeMessagePack(signedBytes));

    expect(signedTx.toMessagePack(), equals(stxO.toMessagePack()));

    // Test golden
    final goldenTx = SignedTransaction.fromJson(
        Encoder.decodeMessagePack(base64Decode(golden)));
    expect(signedTx.transaction.toMessagePack(),
        equals(goldenTx.transaction.toMessagePack()));
    expect(base64Encode(signedBytes), equals(golden));
  });

  test('Test lease', () async {
    final golden =
        'gqNzaWfEQOMmFSIKsZvpW0txwzhmbgQjxv6IyN7BbV5sZ2aNgFbVcrWUnqPpQQxfPhV/wdu9jzEPUU1jAujYtcNCxJ7ONgejdHhujKNhbXTNA+ilY2xvc2XEIEDpNJKIJWTLzpxZpptnVCaJ6aHDoqnqW2Wm6KRCH/xXo2ZlZc0FLKJmds0wsqNnZW6sZGV2bmV0LXYzMy4womdoxCAmCyAJoJOohot5WHIvpeVG7eftF+TYXEx4r7BFJpDt0qJsds00mqJseMQgAQIDBAECAwQBAgMEAQIDBAECAwQBAgMEAQIDBAECAwSkbm90ZcQI6gAVR0Nsv5ajcmN2xCB7bOJP61uswLFk4pwiLFf19j3Dh9Q5BIJYQRxf4Q98AqNzbmTEIOfw+E0GgR358xyNh4sRVfRnHVGhhcIAkIZn9ElYcGihpHR5cGWjcGF5';
    final sender = Address.fromAlgorandAddress(
      '47YPQTIGQEO7T4Y4RWDYWEKV6RTR2UNBQXBABEEGM72ESWDQNCQ52OPASU',
    );
    final receiver = Address.fromAlgorandAddress(
      'PNWOET7LLOWMBMLE4KOCELCX6X3D3Q4H2Q4QJASYIEOF7YIPPQBG3YQ5YI',
    );
    final closeTo = Address.fromAlgorandAddress(
      'IDUTJEUIEVSMXTU4LGTJWZ2UE2E6TIODUKU6UW3FU3UKIQQ77RLUBBBFLA',
    );

    final words =
        // ignore: lines_longer_than_80_chars
        'advice pudding treat near rule blouse same whisper inner electric quit surface sunny dismiss leader blood seat clown cost exist hospital century reform able sponsor';
    final account = await Account.fromSeedPhrase(words.split(' '));

    final lease = 'AQIDBAECAwQBAgMEAQIDBAECAwQBAgMEAQIDBAECAwQ=';
    final tx = await (PaymentTransactionBuilder()
          ..sender = sender
          ..suggestedFeePerByte = BigInt.from(4)
          ..receiver = receiver
          ..amount = BigInt.from(1000)
          ..firstValid = BigInt.from(12466)
          ..lastValid = BigInt.from(13466)
          ..noteB64 = '6gAVR0Nsv5Y='
          ..genesisId = 'devnet-v33.0'
          ..genesisHashB64 = 'JgsgCaCTqIaLeVhyL6XlRu3n7Rfk2FxMeK+wRSaQ7dI='
          ..closeRemainderTo = closeTo
          ..leaseB64 = lease)
        .build();

    final outBytes = Encoder.encodeMessagePack(tx.toMessagePack());
    final outTx =
        PaymentTransaction.fromJson(Encoder.decodeMessagePack(outBytes));

    expect(tx, equals(outTx));
    expect(tx.toMessagePack(), equals(outTx.toMessagePack()));

    // Signed tx
    final signedTx = await tx.sign(account);
    final signedBytes = Encoder.encodeMessagePack(signedTx.toMessagePack());
    final outStx =
        SignedTransaction.fromJson(Encoder.decodeMessagePack(signedBytes));

    expect(signedTx.toMessagePack(), equals(outStx.toMessagePack()));
    expect(signedTx, equals(outStx));

    // Test golden
    final goldenTx = SignedTransaction.fromJson(
        Encoder.decodeMessagePack(base64Decode(golden)));
    expect(signedTx.transaction.toMessagePack(),
        equals(goldenTx.transaction.toMessagePack()));
    expect(base64Encode(signedBytes), equals(golden));
  });

  test('Test transaction group', () async {
    final sender = Address.fromAlgorandAddress(
        'UPYAFLHSIPMJOHVXU2MPLQ46GXJKSDCEMZ6RLCQ7GWB5PRDKJUWKKXECXI');
    final receiver = Address.fromAlgorandAddress(
        'UPYAFLHSIPMJOHVXU2MPLQ46GXJKSDCEMZ6RLCQ7GWB5PRDKJUWKKXECXI');

    final fee = BigInt.from(1000);
    final amount = BigInt.from(2000);
    final genesisId = 'devnet-v1.0';
    final genesisHash = 'sC3P7e2SdbqKJK0tbiCdK9tdSpbe6XeCGKdoNzmlj0E=';
    final firstValid = 710399;
    final note = 'wRKw5cJ0CMo=';

    final tx1 = await (PaymentTransactionBuilder()
          ..sender = sender
          ..flatFee = fee
          ..receiver = receiver
          ..amount = amount
          ..firstValid = BigInt.from(firstValid)
          ..lastValid = BigInt.from(firstValid + 1000)
          ..noteB64 = note
          ..genesisId = genesisId
          ..genesisHashB64 = genesisHash)
        .build();

    final firstValid2 = 710515;
    final note2 = 'dBlHI6BdrIg=';

    final tx2 = await (PaymentTransactionBuilder()
          ..sender = sender
          ..flatFee = fee
          ..receiver = receiver
          ..amount = amount
          ..firstValid = BigInt.from(firstValid2)
          ..lastValid = BigInt.from(firstValid2 + 1000)
          ..noteB64 = note2
          ..genesisId = genesisId
          ..genesisHashB64 = genesisHash)
        .build();

    // Check serialization without group
    var decodedTx1 = getDecodedPaymentTransaction(tx1);
    var decodedTx2 = getDecodedPaymentTransaction(tx2);
    expect(tx1, decodedTx1);
    expect(tx2, decodedTx2);

    final golden1 =
        'gaN0eG6Ko2FtdM0H0KNmZWXNA+iiZnbOAArW/6NnZW6rZGV2bmV0LXYxLjCiZ2jEILAtz+3tknW6iiStLW4gnSvbXUqW3ul3ghinaDc5pY9Bomx2zgAK2uekbm90ZcQIwRKw5cJ0CMqjcmN2xCCj8AKs8kPYlx63ppj1w5410qkMRGZ9FYofNYPXxGpNLKNzbmTEIKPwAqzyQ9iXHremmPXDnjXSqQxEZn0Vih81g9fEak0spHR5cGWjcGF5';
    final golden2 =
        // ignore: lines_longer_than_80_chars
        'gaN0eG6Ko2FtdM0H0KNmZWXNA+iiZnbOAArXc6NnZW6rZGV2bmV0LXYxLjCiZ2jEILAtz+3tknW6iiStLW4gnSvbXUqW3ul3ghinaDc5pY9Bomx2zgAK21ukbm90ZcQIdBlHI6BdrIijcmN2xCCj8AKs8kPYlx63ppj1w5410qkMRGZ9FYofNYPXxGpNLKNzbmTEIKPwAqzyQ9iXHremmPXDnjXSqQxEZn0Vih81g9fEak0spHR5cGWjcGF5';

    var signedTx1 = SignedTransaction(transaction: tx1);
    var signedTx2 = SignedTransaction(transaction: tx2);

    expect(
      base64Encode(Encoder.encodeMessagePack(signedTx1.toMessagePack())),
      golden1,
    );

    expect(
      base64Encode(Encoder.encodeMessagePack(signedTx2.toMessagePack())),
      golden2,
    );

    AtomicTransfer.group([tx1, tx2]);

    // Check serialization with group
    decodedTx1 = getDecodedPaymentTransaction(tx1);
    decodedTx2 = getDecodedPaymentTransaction(tx2);
    expect(tx1, decodedTx1);
    expect(tx2, decodedTx2);

    // Golden
    final goldenTxGroup =
        'gaN0eG6Lo2FtdM0H0KNmZWXNA+iiZnbOAArW/6NnZW6rZGV2bmV0LXYxLjCiZ2jEILAtz+3tknW6iiStLW4gnSvbXUqW3ul3ghinaDc5pY9Bo2dycMQgLiQ9OBup9H/bZLSfQUH2S6iHUM6FQ3PLuv9FNKyt09SibHbOAAra56Rub3RlxAjBErDlwnQIyqNyY3bEIKPwAqzyQ9iXHremmPXDnjXSqQxEZn0Vih81g9fEak0so3NuZMQgo/ACrPJD2Jcet6aY9cOeNdKpDERmfRWKHzWD18RqTSykdHlwZaNwYXmBo3R4boujYW10zQfQo2ZlZc0D6KJmds4ACtdzo2dlbqtkZXZuZXQtdjEuMKJnaMQgsC3P7e2SdbqKJK0tbiCdK9tdSpbe6XeCGKdoNzmlj0GjZ3JwxCAuJD04G6n0f9tktJ9BQfZLqIdQzoVDc8u6/0U0rK3T1KJsds4ACttbpG5vdGXECHQZRyOgXayIo3JjdsQgo/ACrPJD2Jcet6aY9cOeNdKpDERmfRWKHzWD18RqTSyjc25kxCCj8AKs8kPYlx63ppj1w5410qkMRGZ9FYofNYPXxGpNLKR0eXBlo3BheQ==';
    signedTx1 = SignedTransaction(transaction: tx1);
    signedTx2 = SignedTransaction(transaction: tx2);
    final bytes = Uint8List.fromList([
      ...Encoder.encodeMessagePack(signedTx1.toMessagePack()),
      ...Encoder.encodeMessagePack(signedTx2.toMessagePack()),
    ]);

    expect(base64Encode(bytes), equals(goldenTxGroup));

    // Check assign group id
    var result = AtomicTransfer.group([tx1, tx2]);
    expect(result, hasLength(2));

    result = AtomicTransfer.group([tx1, tx2], sender);
    expect(result, hasLength(2));
  });

  test('Test transaction group limit', () async {
    final sender = Address.fromAlgorandAddress(
      'VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ',
    );

    final receiver = Address.fromAlgorandAddress(
      'VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ',
    );

    final tx = await (PaymentTransactionBuilder()
          ..sender = sender
          ..receiver = receiver
          ..amount = BigInt.from(100)
          ..firstValid = BigInt.from(301)
          ..lastValid = BigInt.from(1300))
        .build();

    final transactions =
        List.filled(AtomicTransfer.MAX_TRANSACTION_GROUP_SIZE + 1, tx);

    expect(
      () async => AtomicTransfer.computeGroupId(transactions),
      throwsA((e) =>
          e is AlgorandException && e.message.startsWith('Max. group size is')),
    );
  });

  test('Test transaction group empty', () async {
    expect(
      () async => AtomicTransfer.computeGroupId([]),
      throwsA((e) =>
          e is AlgorandException && e.message == 'Empty transaction list'),
    );
  });

  /// Test that the following 3 builder methods returns the same transaction
  ///    metadataHash, metadataHashUTF8, and metadataHashB64
  /// when given as input the same metadata hash
  /// and that it is different when the input is different
  test('Test meta data hash builder methods', () async {
    final metadataHashUTF8 = 'Hello! This is the metadata hash';
    final metadataHashUTF8Different = 'Hi! I am another metadata hash..';
    final metadataHashBytes = Uint8List.fromList(utf8.encode(metadataHashUTF8));
    final metadataHashB64 = 'SGVsbG8hIFRoaXMgaXMgdGhlIG1ldGFkYXRhIGhhc2g=';

    final address = Address.fromAlgorandAddress(
      'BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4',
    );

    final txBytes = await (AssetConfigTransactionBuilder()
          ..sender = address
          ..flatFee = BigInt.from(10)
          ..firstValid = BigInt.from(322575)
          ..lastValid = BigInt.from(323575)
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI='
          ..totalAssetsToCreate = BigInt.from(100)
          ..decimals = 5
          ..unitName = 'tst'
          ..assetName = 'testcoin'
          ..url = 'https://example.com'
          ..metaData = metadataHashBytes
          ..managerAddress = address
          ..reserveAddress = address
          ..freezeAddress = address
          ..clawbackAddress = address)
        .build();

    final txUTF8 = await (AssetConfigTransactionBuilder()
          ..sender = address
          ..flatFee = BigInt.from(10)
          ..firstValid = BigInt.from(322575)
          ..lastValid = BigInt.from(323575)
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI='
          ..totalAssetsToCreate = BigInt.from(100)
          ..decimals = 5
          ..unitName = 'tst'
          ..assetName = 'testcoin'
          ..url = 'https://example.com'
          ..metadataText = metadataHashUTF8
          ..managerAddress = address
          ..reserveAddress = address
          ..freezeAddress = address
          ..clawbackAddress = address)
        .build();

    final txUTF8Different = await (AssetConfigTransactionBuilder()
          ..sender = address
          ..flatFee = BigInt.from(10)
          ..firstValid = BigInt.from(322575)
          ..lastValid = BigInt.from(323575)
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI='
          ..totalAssetsToCreate = BigInt.from(100)
          ..decimals = 5
          ..unitName = 'tst'
          ..assetName = 'testcoin'
          ..url = 'https://example.com'
          ..metadataText = metadataHashUTF8Different
          ..managerAddress = address
          ..reserveAddress = address
          ..freezeAddress = address
          ..clawbackAddress = address)
        .build();

    final txB64 = await (AssetConfigTransactionBuilder()
          ..sender = address
          ..flatFee = BigInt.from(10)
          ..firstValid = BigInt.from(322575)
          ..lastValid = BigInt.from(323575)
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI='
          ..totalAssetsToCreate = BigInt.from(100)
          ..decimals = 5
          ..unitName = 'tst'
          ..assetName = 'testcoin'
          ..url = 'https://example.com'
          ..metadataB64 = metadataHashB64
          ..managerAddress = address
          ..reserveAddress = address
          ..freezeAddress = address
          ..clawbackAddress = address)
        .build();

    expect(txUTF8.toBytes(), equals(txBytes.toBytes()));
    expect(txUTF8.toBytes(), equals(txB64.toBytes()));
    expect(txUTF8.toBytes(), isNot(equals(txUTF8Different.toBytes())));
  });
}
