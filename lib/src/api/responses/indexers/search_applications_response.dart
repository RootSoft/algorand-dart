import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_applications_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class SearchApplicationsResponse {
  final int currentRound;
  final String? nextToken;

  @JsonKey(name: 'applications', defaultValue: [])
  final List<Application> applications;

  SearchApplicationsResponse({
    required this.applications,
    required this.currentRound,
    this.nextToken,
  });

  factory SearchApplicationsResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchApplicationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchApplicationsResponseToJson(this);
}
