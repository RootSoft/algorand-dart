import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_state_delta_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AccountStateDelta {
  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'delta', defaultValue: [])
  final List<EvalDeltaKeyValue> delta;

  AccountStateDelta({
    required this.address,
    required this.delta,
  });

  factory AccountStateDelta.fromJson(Map<String, dynamic> json) =>
      _$AccountStateDeltaFromJson(json);

  Map<String, dynamic> toJson() => _$AccountStateDeltaToJson(this);
}
