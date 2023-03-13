import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:json_annotation/json_annotation.dart';

class ListAddressConverter implements JsonConverter<List<Address>?, dynamic> {
  const ListAddressConverter();

  @override
  List<Address>? fromJson(dynamic data) {
    if (data == null) return null;

    if (data is! List) {
      return null;
    }

    final serializer = const AddressSerializer();
    return data
        .map(serializer.fromJson)
        .where((e) => e != null)
        .map((e) => e!)
        .toList();
  }

  @override
  dynamic toJson(List<Address>? data) {
    if (data == null) {
      return null;
    }

    return data.map((a) => a.encodedAddress).toList();
  }
}
