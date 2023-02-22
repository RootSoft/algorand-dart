import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/converters/converters.dart';
import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_box_reference.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AppBoxReference implements MessagePackable {
  // Foreign apps start from index 1.  Index 0 is the called App ID.
  // Must apply offset to yield the foreign app index expected by algod.
  static const FOREIGN_APPS_INDEX_OFFSET = 1;
  static const NEW_APP_ID = 0;

  /// The app ID of the app this box belongs to.
  /// Instead of serializing this value, it's used to calculate the appIdx for
  /// AppBoxReference.
  @JsonKey(name: 'i', defaultValue: NEW_APP_ID)
  final int applicationId;

  /// the name of the box unique to the app it belongs to
  @JsonKey(name: 'n')
  @B64ToByteArrayConverter()
  final Uint8List name;

  AppBoxReference({
    required this.applicationId,
    required this.name,
  });

  factory AppBoxReference.utf8({
    required int applicationId,
    required String name,
  }) {
    return AppBoxReference(
      applicationId: applicationId,
      name: Uint8List.fromList(utf8.encode(name)),
    );
  }

  static AppBoxReference fromAppBoxReference(
    AppBoxReference box,
    List<int>? foreignApps,
    int? currentApp,
  ) {
    if (box.applicationId == NEW_APP_ID) {
      return AppBoxReference(applicationId: 0, name: box.name);
    }

    if (foreignApps == null || !foreignApps.contains(box.applicationId)) {
      // If the app references itself in foreign apps, then prefer foreign app index.
      // Otherwise, fallback to comparing against the invoked app (currentApp).
      if (box.applicationId == currentApp) {
        return AppBoxReference(applicationId: 0, name: box.name);
      } else {
        throw AlgorandException(
          message:
              'Box app ID (${box.applicationId}) is not present in the foreign apps array: $currentApp $foreignApps',
        );
      }
    } else {
      return AppBoxReference(
        applicationId:
            foreignApps.indexOf(box.applicationId) + FOREIGN_APPS_INDEX_OFFSET,
        name: box.name,
      );
    }
  }

  /// Get the name, represented as utf8.
  String get nameText => utf8.decode(name);

  /// Get the name, represented as base64.
  String get nameB64 => base64Encode(name);

  factory AppBoxReference.fromJson(Map<String, dynamic> json) =>
      _$AppBoxReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$AppBoxReferenceToJson(this);

  @override
  Map<String, dynamic> toMessagePack() {
    return <String, dynamic>{
      'i': applicationId,
      'n': name,
    };
  }
}
