import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'applications_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class ApplicationsResponse {
  @JsonKey(name: 'applications', defaultValue: [])
  final List<Application> applications;

  ApplicationsResponse({required this.applications});

  factory ApplicationsResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationsResponseToJson(this);
}
