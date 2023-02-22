import 'package:json_annotation/json_annotation.dart';

part 'box_descriptor.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class BoxDescriptor {
  @JsonKey(name: 'name')
  final String name;

  BoxDescriptor({
    required this.name,
  });

  factory BoxDescriptor.fromJson(Map<String, dynamic> json) =>
      _$BoxDescriptorFromJson(json);

  Map<String, dynamic> toJson() => _$BoxDescriptorToJson(this);
}
