import 'dart:convert';

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

  Future<SignedTransaction> expectAssetCreation(
    int decimals,
    String golden,
  ) async {
    final address = Address.fromAlgorandAddress(
      address: 'BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4',
    );

    final url = List<String>.filled(96, 'w').join();
    final metaDataHash = 'fACPO4nRgO55j1ndAK3W6Sgc4APkcyFh';
    final tx = await (AssetConfigTransactionBuilder()
          ..sender = address
          ..suggestedFeePerByte = 10
          ..firstValid = 322575
          ..lastValid = 323575
          ..genesisHashB64 = 'SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI='
          ..totalAssetsToCreate = 100
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
      address: 'VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ',
    );

    final receiver = Address.fromAlgorandAddress(
      address: 'VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ',
    );

    final tx = await (PaymentTransactionBuilder()
          ..sender = sender
          ..receiver = receiver
          ..amount = 100
          ..firstValid = 301
          ..lastValid = 1300)
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

  test('Test asset transfer', () async {});

  test('Test asset freeze', () async {});

  test('Test key reg transaction', () async {});

  test('Test application call', () async {});

  test('Test logic sign', () async {});

  test('Test lease', () async {});

  test('Test transaction group', () async {});

  test('Test transaction group limit', () async {});

  test('Test transaction group empty', () async {});

  test('Test fees', () async {});
}
