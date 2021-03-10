import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

class AddressSerializer implements JsonConverter<Address?, String?> {
  const AddressSerializer();

  @override
  Address? fromJson(String? json) {
    if (json == null) return null;

    try {
      return Address.fromAlgorandAddress(address: json);
    } catch (ex) {
      return null;
    }
  }

  @override
  String toJson(Address? address) => address?.encodedAddress ?? '';
}
