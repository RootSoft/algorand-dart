import 'dart:collection';
import 'dart:typed_data';

import 'package:msgpack_dart/msgpack_dart.dart';

class Encoder {
  /// Encode the message pack.
  static Uint8List encodeMessagePack(Map<String, dynamic> data) {
    final sanitizedMap = <String, dynamic>{};

    // Sanitize all sub maps
    data.forEach((key, value) {
      var v = value;
      if (data[key] is Map<String, dynamic>) {
        final x = data[key] as Map<String, dynamic>;
        v = prepareMessagePack(x);
      }
      sanitizedMap[key] = v;
    });

    return serialize(prepareMessagePack(sanitizedMap));
  }

  /// Sanitize the messagepack before sending it, removing canonical values.
  static Map<String, dynamic> prepareMessagePack(Map<String, dynamic> data) {
    // Sort the map alphabetically
    final sortedData = SplayTreeMap<String, dynamic>.from(data);

    // Sanitize the map and remove canonical values
    sortedData.removeWhere(
      (key, value) =>
          value == null || value == false || (value is String && value.isEmpty),
    );

    return sortedData;
  }
}
