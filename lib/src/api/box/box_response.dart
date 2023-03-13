import 'package:json_annotation/json_annotation.dart';

part 'box_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class BoxResponse {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'value', defaultValue: '')
  final String value;

  BoxResponse({
    required this.name,
    required this.value,
  });

  factory BoxResponse.fromJson(Map<String, dynamic> json) =>
      _$BoxResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BoxResponseToJson(this);
}
