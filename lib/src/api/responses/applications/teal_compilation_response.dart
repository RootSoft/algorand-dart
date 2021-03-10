import 'package:json_annotation/json_annotation.dart';

part 'teal_compilation_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class TealCompilation {
  /// base32 SHA512_256 of program bytes (Address style)
  @JsonKey(name: 'hash')
  final String hash;

  /// base64 encoded program bytes
  @JsonKey(name: 'result')
  final String result;

  TealCompilation({
    required this.hash,
    required this.result,
  });

  factory TealCompilation.fromJson(Map<String, dynamic> json) =>
      _$TealCompilationFromJson(json);

  Map<String, dynamic> toJson() => _$TealCompilationToJson(this);
}
