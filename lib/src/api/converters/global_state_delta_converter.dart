import 'package:algorand_dart/src/api/api.dart';
import 'package:json_annotation/json_annotation.dart';

class GlobalStateDeltaConverter
    extends JsonConverter<List<EvalDeltaKeyValue>, dynamic> {
  const GlobalStateDeltaConverter();

  @override
  List<EvalDeltaKeyValue> fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final delta = json;
      final deltas = <EvalDeltaKeyValue>[];
      for (var gdk in delta.entries) {
        deltas.add(
          EvalDeltaKeyValue(
            key: gdk.key,
            value: EvalDelta.fromMessagePack(gdk.value as Map<String, dynamic>),
          ),
        );
      }
      return deltas;
    }

    return [];
  }

  @override
  dynamic toJson(List<EvalDeltaKeyValue> object) {
    return [];
  }
}
