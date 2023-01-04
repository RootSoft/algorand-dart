import 'package:algorand_dart/src/api/block/block.dart';
import 'package:json_annotation/json_annotation.dart';

part 'block_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class BlockResponse {
  @JsonKey(name: 'block')
  final AlgodBlock block;

  BlockResponse({
    required this.block,
  });

  factory BlockResponse.fromJson(Map<String, dynamic> json) =>
      _$BlockResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BlockResponseToJson(this);
}
