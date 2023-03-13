import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'applications_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class ApplicationsResponse {
  @JsonKey(name: 'applications', defaultValue: [])
  final List<Application> applications;

  /// Round at which the results were computed.
  @JsonKey(name: 'current-round', defaultValue: 0)
  final int currentRound;

  /// Used for pagination, when making another request provide this token
  /// with the next parameter.
  @JsonKey(name: 'next-token')
  final String? nextToken;

  ApplicationsResponse({
    required this.applications,
    required this.currentRound,
    required this.nextToken,
  });

  factory ApplicationsResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationsResponseToJson(this);
}
