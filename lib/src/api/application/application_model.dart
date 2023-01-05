import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class Application {
  /// application index.
  final int id;

  /// application parameters.
  final ApplicationParams params;

  /// Round when this application was created.
  final int? createdAtRound;

  /// Whether or not this application is currently deleted.
  @JsonKey(name: 'deleted', defaultValue: false)
  final bool deleted;

  /// Round when this application was deleted.
  final int? deletedAtRound;

  Application({
    required this.id,
    required this.params,
    required this.deleted,
    this.createdAtRound,
    this.deletedAtRound,
  });

  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}
