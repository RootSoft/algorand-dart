import 'dart:convert';

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
        AppBoxReference.fromAppBoxReference(abr, [1, 3, 4, appId], appId - 1);

    expect(AppBoxReference(applicationId: 4, name: abr.name), equals(expected));
  });

  test('test app index does not exist', () async {
    final appId = 7;
    final abr = genWithAppId(appId);

    expect(
      () async =>
          AppBoxReference.fromAppBoxReference(abr, [1, 3, 4], appId - 1),
      throwsA(
          (e) => e is AlgorandException && e.message.startsWith('Box app ID')),
    );
  });

  test('test new app id', () async {
    final abr = genWithNewAppId();

    final expected = AppBoxReference.fromAppBoxReference(abr, [], 1);

    expect(AppBoxReference(applicationId: 0, name: abr.name), equals(expected));
  });

  test('test fallback to current pp', () async {
    // Mirrors priority search in goal from
    // `cmd/goal/application.go::translateBoxRefs`.
    final appId = 7;
    final abr = genWithAppId(appId);

    // Prefer foreign apps index when present.
    final expected =
        AppBoxReference.fromAppBoxReference(abr, [1, 3, 4, appId], appId);
    expect(AppBoxReference(applicationId: 4, name: abr.name), equals(expected));

    // Prefer foreign apps index when present.
    final expected2 =
        AppBoxReference.fromAppBoxReference(abr, [1, 3, 4], appId);
    expect(
        AppBoxReference(applicationId: 0, name: abr.name), equals(expected2));
  });
}
