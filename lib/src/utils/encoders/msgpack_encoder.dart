import 'dart:collection';
import 'dart:typed_data';

import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

class Encoder {
  /// Encode the messagepack.
  static Uint8List encodeMessagePack(Map<String, dynamic> data) {
    final x = prepareMessagePack(data);
    return serialize(prepareMessagePack(x));
  }

  /// Decodes the messagepack.
  /// TODO Array?
  static Map<String, dynamic> decodeMessagePack(Uint8List bytes) {
    final decoded = deserialize(bytes);
    if (decoded is Map<dynamic, dynamic>) {
      return convertMap(decoded);
    }

    return <String, dynamic>{};
  }

  static Map<String, dynamic> convertMap(Map<dynamic, dynamic> data) {
    return data.map((key, value) {
      var x = value;
      if (x is Map<dynamic, dynamic>) {
        x = convertMap(x);
      }

      return MapEntry(key.toString(), x);
    });
  }

  /// Prepare the messagepack and sanitize it.
  static Map<String, dynamic> prepareMessagePack(Map<String, dynamic> data) {
    final sanitizedMap = <String, dynamic>{};

    // Sanitize all sub maps
    data.forEach((key, value) {
      var v = value;
      if (data[key] is Map<String, dynamic>) {
        final x = data[key] as Map<String, dynamic>;
        v = prepareMessagePack(x);
      } else if (data[key] is List<Map<String, dynamic>>) {
        final l = <Map<String, dynamic>>[];
        final values = data[key] as List<Map<String, dynamic>>;
        for (var value in values) {
          l.add(prepareMessagePack(value));
        }

        v = l;
      } else if (data[key] is MessagePackable) {
        final x = data[key] as MessagePackable;
        v = prepareMessagePack(x.toMessagePack());
      }

      sanitizedMap[key] = v;
    });

    return sanitizeMessagePack(sanitizedMap);
  }

  /// Sanitize the messagepack before sending it, removing canonical values.
  static Map<String, dynamic> sanitizeMessagePack(Map<String, dynamic> data) {
    // Sort the map alphabetically
    final sortedData = SplayTreeMap<String, dynamic>.from(data);

    // Sanitize the map and remove canonical values
    sortedData.removeWhere(
      (key, value) =>
          value == null ||
          value == false ||
          (value is Map && value.isEmpty) ||
          (value is List && value.isEmpty) ||
          (value is String && value.isEmpty || (value is int && value == 0)),
    );

    return sortedData;
  }
}
