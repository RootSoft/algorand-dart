import 'package:algorand_dart/src/api/api.dart';
import 'package:json_annotation/json_annotation.dart';

class LocalStateDeltaConverter
    extends JsonConverter<List<AccountStateDelta>, dynamic> {
  const LocalStateDeltaConverter();

  @override
  List<AccountStateDelta> fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final delta = json;
      final state = <AccountStateDelta>[];

      for (var entry in delta.entries) {
        final values = entry.value as Map<String, dynamic>;
        final deltas = <EvalDeltaKeyValue>[];
        for (var entry2 in values.entries) {
          deltas.add(
            EvalDeltaKeyValue(
              key: entry2.key,
              value: EvalDelta.fromMessagePack(
                  entry2.value as Map<String, dynamic>),
            ),
          );
        }

        state.add(AccountStateDelta(address: null, delta: deltas));
      }

      return state;
    }

    return [];
  }

  @override
  dynamic toJson(List<AccountStateDelta> object) {
    return [];
  }
}
