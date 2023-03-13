import 'dart:convert';
import 'dart:typed_data';

class AppBoxReference {
  /// The app ID of the app this box belongs to.
  /// Instead of serializing this value, it's used to calculate the appIdx for
  /// AppBoxReference.
  final int applicationId;

  /// the name of the box unique to the app it belongs to
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

  /// Get the name, represented as utf8.
  String get nameText => utf8.decode(name);

  /// Get the name, represented as base64.
  String get nameB64 => base64Encode(name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppBoxReference &&
          runtimeType == other.runtimeType &&
          applicationId == other.applicationId &&
          name == other.name;

  @override
  int get hashCode => applicationId.hashCode ^ name.hashCode;
}
