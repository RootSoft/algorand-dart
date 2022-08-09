import 'dart:typed_data';

import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

class AddressSerializer implements JsonConverter<Address?, dynamic> {
  const AddressSerializer();

  @override
  Address? fromJson(dynamic data) {
    if (data == null) return null;

    if (data is Uint8List) {
      return Address(publicKey: data);
    }

    if (data is String) {
      try {
        return Address.fromAlgorandAddress(data);
      } catch (ex) {
        return null;
      }
    }

    return null;
  }

  @override
  String toJson(Address? address) => address?.encodedAddress ?? '';
}
