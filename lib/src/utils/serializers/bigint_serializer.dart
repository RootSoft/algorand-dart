import 'package:json_annotation/json_annotation.dart';

class BigIntSerializer implements JsonConverter<BigInt, dynamic> {
  const BigIntSerializer();

  @override
  BigInt fromJson(dynamic data) {
    if (data is BigInt) {
      return data;
    }

    if (data is String) {
      return BigInt.parse(data);
    }

    if (data is num) {
      return BigInt.from(data);
    }

    return BigInt.zero;
  }

  @override
  String toJson(BigInt data) => data.toString();
}

class NullableBigIntSerializer implements JsonConverter<BigInt?, dynamic> {
  const NullableBigIntSerializer();

  @override
  BigInt? fromJson(dynamic data) {
    if (data is String) {
      return BigInt.parse(data);
    }

    if (data is num) {
      return BigInt.from(data);
    }

    if (data is BigInt) {
      return data;
    }

    return BigInt.zero;
  }

  @override
  String toJson(BigInt? data) => data?.toString() ?? '';
}
