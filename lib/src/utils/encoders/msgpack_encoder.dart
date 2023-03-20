import 'dart:collection';
import 'dart:typed_data';

import 'package:algorand_dart/src/api/encoding/algorand_codec.dart';
import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:algorand_msgpack/algorand_msgpack.dart';

class Encoder {
  /// Encode the messagepack.
  static Uint8List encodeMessagePack(Map<String, dynamic> data) {
    final x = prepareMessagePack(data);
    return serialize(prepareMessagePack(x));
  }

  /// Decodes the messagepack.
  static Map<String, dynamic> decodeMessagePack(Uint8List bytes) {
    final decoded = deserialize(
      bytes,
      codec: const AlgorandCodec(),
    );

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

      if (x is List<int>) {
        x = Uint8List.fromList(x);
      } else if (x is List<dynamic>) {
        x = convertList(x);
      }

      return MapEntry(key.toString(), x);
    });
  }

  static List<dynamic> convertList(List<dynamic> data) {
    final x = data.map((e) {
      if (e is Map<dynamic, dynamic>) {
        return convertMap(e);
      }

      if (e is List<int>) {
        return Uint8List.fromList(e);
      }

      if (e is List<dynamic>) {
        return convertList(e);
      }

      return e;
    }).toList();

    return x;
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
          (value is BigInt && value == BigInt.zero) ||
          (value is String && value.isEmpty || (value is int && value == 0)),
    );

    return sortedData;
  }
}
