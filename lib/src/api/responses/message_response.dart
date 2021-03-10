import 'package:json_annotation/json_annotation.dart';

part 'message_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class MessageResponse {
  @JsonKey(name: 'message')
  final String message;

  MessageResponse({required this.message});

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessageResponseToJson(this);
}
