import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  AppBoxReference genWithAppId(int id) {
    return AppBoxReference(applicationId: id, name: ascii.encode('example'));
  }

  AppBoxReference genWithNewAppId() {
    return AppBoxReference(applicationId: 0, name: ascii.encode('example'));
  }

  test('test app index exists', () async {
    final appId = 7;
    final abr = genWithAppId(appId);
    final expected =
        BoxReference.fromAppBoxReference(abr, [1, 3, 4, appId], appId - 1);

    expect(BoxReference(appIndex: 4, name: abr.name), equals(expected));
  });

  test('test app index does not exist', () async {
    final appId = 7;
    final abr = genWithAppId(appId);

    expect(
      () async => BoxReference.fromAppBoxReference(abr, [1, 3, 4], appId - 1),
      throwsA(
          (e) => e is AlgorandException && e.message.startsWith('Box app ID')),
    );
  });

  test('test new app id', () async {
    final abr = genWithNewAppId();

    final expected = BoxReference.fromAppBoxReference(abr, [], 1);

    expect(BoxReference(appIndex: 0, name: abr.name), equals(expected));
  });

  test('test fallback to current pp', () async {
    // Mirrors priority search in goal from
    // `cmd/goal/application.go::translateBoxRefs`.
    final appId = 7;
    final abr = genWithAppId(appId);

    // Prefer foreign apps index when present.
    final expected =
        BoxReference.fromAppBoxReference(abr, [1, 3, 4, appId], appId);
    expect(BoxReference(appIndex: 4, name: abr.name), equals(expected));

    // Prefer foreign apps index when present.
    final expected2 = BoxReference.fromAppBoxReference(abr, [1, 3, 4], appId);
    expect(BoxReference(appIndex: 0, name: abr.name), equals(expected2));
  });

  test('test box serialization', () async {
    final tx =
        'i6RhcGFhlsQEExz+t8QBAMQIAAAAACye4FfECAAAAAAs2NxIxAgAAAAAAAATJMQgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACkYXBhc5HOIPDs/KRhcGJ4koGhbsQIAAAAACDw7PyBoW7EKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACDw7PykYXBpZM49KOEJomZ2zgGhClWjZ2VurG1haW5uZXQtdjEuMKJnaMQgwGHE2Pwdvd7S12BL5FaOP20EGYesN73ktiC1qzkkit+jZ3JwxCAA7SZ5a+gr6h7fZTkziG5SrqfgUzffYHYl4+64l3dpuqJsds4BoQ49o3NuZMQg1UDRaWq6dzSqvhixlzR7csPOhP2PEZ+axkr++8+lcyKkdHlwZaRhcHBs';

    final rawTxnMsgpack = base64Decode(tx);
    final o = Encoder.decodeMessagePack(rawTxnMsgpack);
    final unsignedTxn = ApplicationTransaction.fromJson(o);
    final b = Encoder.encodeMessagePack(unsignedTxn.toMessagePack());
    final decoded = Encoder.decodeMessagePack(b);

    final expectedBoxReference = BoxReference(
      appIndex: 0,
      name: Uint8List.fromList([0, 0, 0, 0, 32, 240, 236, 252]),
    );

    expect(o, equals(decoded));
    expect(tx, equals(base64Encode(b)));
    expect(unsignedTxn.boxes.length, equals(2));
    expect(unsignedTxn.boxes[0], equals(expectedBoxReference));
  });
}
