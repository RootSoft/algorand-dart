import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
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

  test('test Split', () async {
    final goldenProgram =
        'ASAIAcCWsQICAMDEB2QekE4mAyCztwQn0+DycN+vsk+vJWcsoz/b7NDS6i33HOkvTpf+YiC3qUpIgHGWE8/1LPh9SGCalSN7IaITeeWSXbfsS5wsXyC4kBQ38Z8zcwWVAym4S8vpFB/c0XC6R4mnPi9EBADsPDEQIhIxASMMEDIEJBJAABkxCSgSMQcyAxIQMQglEhAxAiEEDRAiQAAuMwAAMwEAEjEJMgMSEDMABykSEDMBByoSEDMACCEFCzMBCCEGCxIQMwAIIQcPEBA=';
    final goldenAddress =
        'HDY7A4VHBWQWQZJBEMASFOUZKBNGWBMJEMUXAGZ4SPIRQ6C24MJHUZKFGY';

    final owner = Address.fromAlgorandAddress(
      address: 'WO3QIJ6T4DZHBX5PWJH26JLHFSRT7W7M2DJOULPXDTUS6TUX7ZRIO4KDFY',
    );
    final receiver1 = Address.fromAlgorandAddress(
      address: 'W6UUUSEAOGLBHT7VFT4H2SDATKKSG6ZBUIJXTZMSLW36YS44FRP5NVAU7U',
    );
    final receiver2 = Address.fromAlgorandAddress(
      address: 'XCIBIN7RT4ZXGBMVAMU3QS6L5EKB7XGROC5EPCNHHYXUIBAA5Q6C5Y7NEU',
    );

    final minPay = 10000;
    final rat1 = 30;
    final rat2 = 100;

    final contract = Split.create(
      owner: owner,
      receiver1: receiver1,
      receiver2: receiver2,
      rat1: rat1,
      rat2: rat2,
      expiryRound: 123456,
      minPay: minPay,
      maxFee: 5000000,
    );

    expect(contract.address.encodedAddress, equals(goldenAddress));
    expect(base64Encode(contract.program), equals(goldenProgram));

    final gh = 'f4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGk=';
    final transactions = await Split.getTransactions(
      contract: contract,
      amount: minPay * (rat1 + rat2),
      firstValid: 1,
      lastValid: 100,
      feePerByte: 10000,
      genesisHash: gh,
    );

    final splitTransactionGolden =
        'gqRsc2lngaFsxM4BIAgBwJaxAgIAwMQHZB6QTiYDILO3BCfT4PJw36+yT68lZyyjP9vs0NLqLfcc6S9Ol/5iILepSkiAcZYTz/Us+H1IYJqVI3shohN55ZJdt+xLnCxfILiQFDfxnzNzBZUDKbhLy+kUH9zRcLpHiac+L0QEAOw8MRAiEjEBIwwQMgQkEkAAGTEJKBIxBzIDEhAxCCUSEDECIQQNECJAAC4zAAAzAQASMQkyAxIQMwAHKRIQMwEHKhIQMwAIIQULMwEIIQYLEhAzAAghBw8QEKN0eG6Jo2FtdM4ABJPgo2ZlZc4AId/gomZ2AaJnaMQgf4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGmjZ3JwxCBLA74bTV35FJNL1h0K9ZbRU24b4M1JRkD1YTogvvDXbqJsdmSjcmN2xCC3qUpIgHGWE8/1LPh9SGCalSN7IaITeeWSXbfsS5wsX6NzbmTEIDjx8HKnDaFoZSEjASK6mVBaawWJIylwGzyT0Rh4WuMSpHR5cGWjcGF5gqRsc2lngaFsxM4BIAgBwJaxAgIAwMQHZB6QTiYDILO3BCfT4PJw36+yT68lZyyjP9vs0NLqLfcc6S9Ol/5iILepSkiAcZYTz/Us+H1IYJqVI3shohN55ZJdt+xLnCxfILiQFDfxnzNzBZUDKbhLy+kUH9zRcLpHiac+L0QEAOw8MRAiEjEBIwwQMgQkEkAAGTEJKBIxBzIDEhAxCCUSEDECIQQNECJAAC4zAAAzAQASMQkyAxIQMwAHKRIQMwEHKhIQMwAIIQULMwEIIQYLEhAzAAghBw8QEKN0eG6Jo2FtdM4AD0JAo2ZlZc4AId/gomZ2AaJnaMQgf4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGmjZ3JwxCBLA74bTV35FJNL1h0K9ZbRU24b4M1JRkD1YTogvvDXbqJsdmSjcmN2xCC4kBQ38Z8zcwWVAym4S8vpFB/c0XC6R4mnPi9EBADsPKNzbmTEIDjx8HKnDaFoZSEjASK6mVBaawWJIylwGzyT0Rh4WuMSpHR5cGWjcGF5';

    expect(base64Encode(transactions), equals(splitTransactionGolden));
  });

  test('test Periodic Payment', () async {
    final goldenAddress =
        'JMS3K4LSHPULANJIVQBTEDP5PZK6HHMDQS4OKHIMHUZZ6OILYO3FVQW7IY';

    final goldenProgram =
        // ignore: lines_longer_than_80_chars
        'ASAHAegHZABfoMIevKOVASYCIAECAwQFBgcIAQIDBAUGBwgBAgMEBQYHCAECAwQFBgcIIJKvkYTkEzwJf2arzJOxERsSogG9nQzKPkpIoc4TzPTFMRAiEjEBIw4QMQIkGCUSEDEEIQQxAggSEDEGKBIQMQkyAxIxBykSEDEIIQUSEDEJKRIxBzIDEhAxAiEGDRAxCCUSEBEQ';

    final receiver = Address.fromAlgorandAddress(
      address: 'SKXZDBHECM6AS73GVPGJHMIRDMJKEAN5TUGMUPSKJCQ44E6M6TC2H2UJ3I',
    );
    final lease = 'AQIDBAUGBwgBAgMEBQYHCAECAwQFBgcIAQIDBAUGBwg=';

    // Create the contract
    final contract = PeriodicPayment.create(
      receiver: receiver,
      amount: 500000,
      withdrawingWindow: 95,
      period: 100,
      fee: 1000,
      expiryRound: 2445756,
      lease: lease,
    );

    expect(contract.address.encodedAddress, equals(goldenAddress));
    expect(base64Encode(contract.program), equals(goldenProgram));

    final genesisHash = 'f4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGk=';
    final goldenTx =
        'gqRsc2lngaFsxJkBIAcB6AdkAF+gwh68o5UBJgIgAQIDBAUGBwgBAgMEBQYHCAECAwQFBgcIAQIDBAUGBwggkq+RhOQTPAl/ZqvMk7ERGxKiAb2dDMo+SkihzhPM9MUxECISMQEjDhAxAiQYJRIQMQQhBDECCBIQMQYoEhAxCTIDEjEHKRIQMQghBRIQMQkpEjEHMgMSEDECIQYNEDEIJRIQERCjdHhuiaNhbXTOAAehIKNmZWXNA+iiZnbNBLCiZ2jEIH+DsWV/8fxTuS3BgUih1l38LUsfo9Z3KErd0gASbZBpomx2zQUPomx4xCABAgMEBQYHCAECAwQFBgcIAQIDBAUGBwgBAgMEBQYHCKNyY3bEIJKvkYTkEzwJf2arzJOxERsSogG9nQzKPkpIoc4TzPTFo3NuZMQgSyW1cXI76LA1KKwDMg39flXjnYOEuOUdDD0znzkLw7akdHlwZaNwYXk=';

    final signedTx = await PeriodicPayment.getWithdrawalTransaction(
      contract: contract,
      firstValid: 1200,
      genesisHash: genesisHash,
      feePerByte: 0,
    );

    expect(signedTx.toBase64(), equals(goldenTx));
  });

  test('test Dynamic Fee', () async {
    final goldenAddress =
        'GCI4WWDIWUFATVPOQ372OZYG52EULPUZKI7Y34MXK3ZJKIBZXHD2H5C5TI';
    final goldenProgram =
        'ASAFAgGIJ7lgumAmAyD+vKC7FEpaTqe0OKRoGsgObKEFvLYH/FZTJclWlfaiEyDmmpYeby1feshmB5JlUr6YI17TM2PKiJGLuck4qRW2+SB/g7Flf/H8U7ktwYFIodZd/C1LH6PWdyhK3dIAEm2QaTIEIhIzABAjEhAzAAcxABIQMwAIMQESEDEWIxIQMRAjEhAxBygSEDEJKRIQMQgkEhAxAiUSEDEEIQQSEDEGKhIQ';

    // Create the contract
    final receiver = Address.fromAlgorandAddress(
      address: '726KBOYUJJNE5J5UHCSGQGWIBZWKCBN4WYD7YVSTEXEVNFPWUIJ7TAEOPM',
    );

    final closeTo = Address.fromAlgorandAddress(
      address: '42NJMHTPFVPXVSDGA6JGKUV6TARV5UZTMPFIREMLXHETRKIVW34QFSDFRE',
    );

    final lease = 'f4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGk=';

    final contract = DynamicFee.create(
      receiver: receiver,
      amount: 5000,
      firstValid: 12345,
      lastValid: 12346,
      closeTo: closeTo,
      lease: lease,
    );

    expect(contract.address.encodedAddress, equals(goldenAddress));
    expect(base64Encode(contract.program), equals(goldenProgram));

    // Sign contract
    final pk1 = base64Decode(
        // ignore: lines_longer_than_80_chars
        'cv8E0Ln24FSkwDgGeuXKStOTGcze5u8yldpXxgrBxumFPYdMJymqcGoxdDeyuM8t6Kxixfq0PJCyJP71uhYT7w==');
    final pk2 = base64Decode(
        // ignore: lines_longer_than_80_chars
        '2qjz96Vj9M6YOqtNlfJUOKac13EHCXyDty94ozCjuwwriI+jzFgStFx9E6kEk1l4+lFsW4Te2PY1KV8kNcccRg==');

    final sender = await Account.fromSeed(Uint8List.sublistView(pk1, 0, 32));

    final account2 = await Account.fromSeed(Uint8List.sublistView(pk2, 0, 32));

    final dynamicFee = await DynamicFee.sign(
      contract: contract,
      sender: sender,
      genesisHash: 'f4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGk=',
    );

    final encodedLsig = dynamicFee.signature.toBase64();
    final encodedTx = dynamicFee.transaction.toBase64();
    final goldenTx =
        'iqNhbXTNE4ilY2xvc2XEIOaalh5vLV96yGYHkmVSvpgjXtMzY8qIkYu5yTipFbb5o2ZlZc0D6KJmds0wOaJnaMQgf4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGmibHbNMDqibHjEIH+DsWV/8fxTuS3BgUih1l38LUsfo9Z3KErd0gASbZBpo3JjdsQg/ryguxRKWk6ntDikaBrIDmyhBby2B/xWUyXJVpX2ohOjc25kxCCFPYdMJymqcGoxdDeyuM8t6Kxixfq0PJCyJP71uhYT76R0eXBlo3BheQ==';
    final goldenSig =
        'gqFsxLEBIAUCAYgnuWC6YCYDIP68oLsUSlpOp7Q4pGgayA5soQW8tgf8VlMlyVaV9qITIOaalh5vLV96yGYHkmVSvpgjXtMzY8qIkYu5yTipFbb5IH+DsWV/8fxTuS3BgUih1l38LUsfo9Z3KErd0gASbZBpMgQiEjMAECMSEDMABzEAEhAzAAgxARIQMRYjEhAxECMSEDEHKBIQMQkpEhAxCCQSEDECJRIQMQQhBBIQMQYqEhCjc2lnxEAhLNdfdDp9Wbi0YwsEQCpP7TVHbHG7y41F4MoESNW/vL1guS+5Wj4f5V9fmM63/VKTSMFidHOSwm5o+pbV5lYH';

    expect(encodedLsig, equals(goldenSig));
    expect(encodedTx, equals(goldenTx));

    final transactions = await DynamicFee.getReimbursementTransactions(
      transaction: dynamicFee.transaction,
      signature: dynamicFee.signature,
      account: account2,
      feePerByte: 1234,
    );

    final goldenTxs =
        'gqNzaWfEQJBNVry9qdpnco+uQzwFicUWHteYUIxwDkdHqY5Qw2Q8Fc2StrQUgN+2k8q4rC0LKrTMJQnE+mLWhZgMMJvq3QCjdHhuiqNhbXTOAAWq6qNmZWXOAATzvqJmds0wOaJnaMQgf4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGmjZ3JwxCCCVfqhCinRBXKMIq9eSrJQIXZ+7iXUTig91oGd/mZEAqJsds0wOqJseMQgf4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGmjcmN2xCCFPYdMJymqcGoxdDeyuM8t6Kxixfq0PJCyJP71uhYT76NzbmTEICuIj6PMWBK0XH0TqQSTWXj6UWxbhN7Y9jUpXyQ1xxxGpHR5cGWjcGF5gqRsc2lngqFsxLEBIAUCAYgnuWC6YCYDIP68oLsUSlpOp7Q4pGgayA5soQW8tgf8VlMlyVaV9qITIOaalh5vLV96yGYHkmVSvpgjXtMzY8qIkYu5yTipFbb5IH+DsWV/8fxTuS3BgUih1l38LUsfo9Z3KErd0gASbZBpMgQiEjMAECMSEDMABzEAEhAzAAgxARIQMRYjEhAxECMSEDEHKBIQMQkpEhAxCCQSEDECJRIQMQQhBBIQMQYqEhCjc2lnxEAhLNdfdDp9Wbi0YwsEQCpP7TVHbHG7y41F4MoESNW/vL1guS+5Wj4f5V9fmM63/VKTSMFidHOSwm5o+pbV5lYHo3R4boujYW10zROIpWNsb3NlxCDmmpYeby1feshmB5JlUr6YI17TM2PKiJGLuck4qRW2+aNmZWXOAAWq6qJmds0wOaJnaMQgf4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGmjZ3JwxCCCVfqhCinRBXKMIq9eSrJQIXZ+7iXUTig91oGd/mZEAqJsds0wOqJseMQgf4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGmjcmN2xCD+vKC7FEpaTqe0OKRoGsgObKEFvLYH/FZTJclWlfaiE6NzbmTEIIU9h0wnKapwajF0N7K4zy3orGLF+rQ8kLIk/vW6FhPvpHR5cGWjcGF5';
    //expect(base64Encode(transactions), goldenTxs);

    expect(transactions, equals(base64Decode(goldenTxs)));
  });

  test('test Limit order', () async {
    final goldenAddress =
        'LXQWT2XLIVNFS54VTLR63UY5K6AMIEWI7YTVE6LB4RWZDBZKH22ZO3S36I';
    final goldenProgram =
        'ASAKAAHAlrECApBOBLlgZB7AxAcmASD+vKC7FEpaTqe0OKRoGsgObKEFvLYH/FZTJclWlfaiEzEWIhIxECMSEDEBJA4QMgQjEkAAVTIEJRIxCCEEDRAxCTIDEhAzARAhBRIQMwERIQYSEDMBFCgSEDMBEzIDEhAzARIhBx01AjUBMQghCB01BDUDNAE0Aw1AACQ0ATQDEjQCNAQPEEAAFgAxCSgSMQIhCQ0QMQcyAxIQMQgiEhAQ';

    // Create the contract
    final owner = Address.fromAlgorandAddress(
      address: '726KBOYUJJNE5J5UHCSGQGWIBZWKCBN4WYD7YVSTEXEVNFPWUIJ7TAEOPM',
    );

    final contract = LimitOrder.create(
      owner: owner,
      assetId: 12345,
      ratn: 30,
      ratd: 100,
      expirationRound: 123456,
      minTrade: 10000,
      maxFee: 5000000,
    );

    expect(contract.address.encodedAddress, equals(goldenAddress));
    expect(base64Encode(contract.program), equals(goldenProgram));

    // Test swap transaction
    final pk1 =
        // ignore: lines_longer_than_80_chars
        'DTKVj7KMON3GSWBwMX9McQHtaDDi8SDEBi0bt4rOxlHNRahLa0zVG+25BDIaHB1dSoIHIsUQ8FFcdnCdKoG+Bg==';
    final sender = await Account.fromSeed(
      Uint8List.sublistView(base64Decode(pk1), 0, 32),
    );

    final genesisHash = 'f4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGk=';

    // Verify transactions with correct exchange rate.
    final transactions = await LimitOrder.getSwapAssetsTransaction(
      contract: contract,
      assetAmount: 3000,
      microAlgoAmount: 10000,
      sender: sender,
      firstValid: 1234,
      lastValid: 2234,
      genesisHash: genesisHash,
      feePerByte: 10,
    );

    final goldenTx1 =
        'gqRsc2lngaFsxLcBIAoAAcCWsQICkE4EuWBkHsDEByYBIP68oLsUSlpOp7Q4pGgayA5soQW8tgf8VlMlyVaV9qITMRYiEjEQIxIQMQEkDhAyBCMSQABVMgQlEjEIIQQNEDEJMgMSEDMBECEFEhAzAREhBhIQMwEUKBIQMwETMgMSEDMBEiEHHTUCNQExCCEIHTUENQM0ATQDDUAAJDQBNAMSNAI0BA8QQAAWADEJKBIxAiEJDRAxBzIDEhAxCCISEBCjdHhuiaNhbXTNJxCjZmVlzQisomZ2zQTSomdoxCB/g7Flf/H8U7ktwYFIodZd/C1LH6PWdyhK3dIAEm2QaaNncnDEIKz368WOGpdE/Ww0L8wUu5Ly2u2bpG3ZSMKCJvcvGApTomx2zQi6o3JjdsQgzUWoS2tM1RvtuQQyGhwdXUqCByLFEPBRXHZwnSqBvgajc25kxCBd4Wnq60VaWXeVmuPt0x1XgMQSyP4nUnlh5G2Rhyo+taR0eXBlo3BheQ==';
    final goldenTx2 =
        'gqNzaWfEQKXv8Z6OUDNmiZ5phpoQJHmfKyBal4gBZLPYsByYnlXCAlXMBeVFG5CLP1k5L6BPyEG2/XIbjbyM0CGG55CxxAKjdHhuiqRhYW10zQu4pGFyY3bEIP68oLsUSlpOp7Q4pGgayA5soQW8tgf8VlMlyVaV9qITo2ZlZc0JJKJmds0E0qJnaMQgf4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGmjZ3JwxCCs9+vFjhqXRP1sNC/MFLuS8trtm6Rt2UjCgib3LxgKU6Jsds0IuqNzbmTEIM1FqEtrTNUb7bkEMhocHV1KggcixRDwUVx2cJ0qgb4GpHR5cGWlYXhmZXKkeGFpZM0wOQ==';

    final goldenTxs = Uint8List.fromList(
        [...base64Decode(goldenTx1), ...base64Decode(goldenTx2)]);

    expect(transactions, equals(goldenTxs));
  });
}
