import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:json_annotation/json_annotation.dart';

class ListAddressConverter implements JsonConverter<List<Address>, dynamic> {
  const ListAddressConverter();

  @override
  List<Address> fromJson(dynamic data) {
    if (data == null) return [];

    if (data is! List) {
      return [];
    }

    final serializer = const AddressSerializer();
    return data
        .map(serializer.fromJson)
        .where((e) => e != null)
        .map((e) => e!)
        .toList();
  }

  @override
  List<String> toJson(List<Address> data) {
    return data.map((a) => a.encodedAddress).toList();
  }
}
