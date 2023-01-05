import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_local_state_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class ApplicationLocalState {
  /// The application which this local state is for.
  final int id;

  /// The schema (required)
  final ApplicationStateSchema schema;

  /// Round when account closed out of the application.
  final int? closedOutAtRound;

  /// Whether or not the application local state is currently deleted from
  /// its account.
  final bool? deleted;

  /// storage
  @JsonKey(name: 'key-value', defaultValue: [])
  final List<TealKeyValue> keyValue;

  /// Round when the account opted into the application.
  final int? optedInAtRound;

  ApplicationLocalState({
    required this.id,
    required this.schema,
    required this.keyValue,
    this.closedOutAtRound,
    this.deleted,
    this.optedInAtRound,
  });

  factory ApplicationLocalState.fromJson(Map<String, dynamic> json) =>
      _$ApplicationLocalStateFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationLocalStateToJson(this);
}
