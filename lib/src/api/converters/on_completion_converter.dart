import 'package:algorand_dart/src/models/models.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

class OnCompletionConverter implements JsonConverter<OnCompletion?, dynamic> {
  const OnCompletionConverter();

  @override
  OnCompletion? fromJson(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is OnCompletion) {
      return data;
    }

    if (data is String) {
      return $enumDecodeNullable(kOnCompletionEnumMap, data);
    }

    if (data is int) {
      return OnCompletion.values.firstWhereOrNull((e) => e.value == data);
    }

    return null;
  }

  @override
  dynamic toJson(OnCompletion? data) => data != null ? data.value : null;
}
