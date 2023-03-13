import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_lookup_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class ApplicationResponse {
  /// Round at which the results were computed.
  @JsonKey(name: 'current-round', defaultValue: 0)
  final int currentRound;
  final Application? application;

  ApplicationResponse({required this.currentRound, required this.application});

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationResponseToJson(this);
}
