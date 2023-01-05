import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_logs_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class ApplicationLogsResponse {
  /// Application index.
  @JsonKey(name: 'application-id')
  final int? applicationId;

  /// Round at which the results were computed.
  @JsonKey(name: 'current-round')
  final int? currentRound;

  @JsonKey(name: 'log-data', defaultValue: [])
  final List<ApplicationLogData> logData;

  @JsonKey(name: 'next-token')
  final String? nextToken;

  ApplicationLogsResponse({
    required this.logData,
    this.applicationId,
    this.currentRound,
    this.nextToken,
  });

  factory ApplicationLogsResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationLogsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationLogsResponseToJson(this);
}
