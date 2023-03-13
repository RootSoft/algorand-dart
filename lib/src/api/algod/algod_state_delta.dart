import 'dart:typed_data';

import 'package:algorand_dart/src/utils/serializers/bigint_serializer.dart';
import 'package:algorand_dart/src/utils/serializers/byte_array_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'algod_state_delta.g.dart';

@JsonSerializable()
class AlgodStateDelta {
  @JsonKey(name: 'at', defaultValue: 0)
  final int action;

  @JsonKey(name: 'bs')
  @NullableByteArraySerializer()
  final Uint8List? bytes;

  @JsonKey(name: 'ui')
  @NullableBigIntSerializer()
  final BigInt? uint;

  AlgodStateDelta({
    required this.action,
    required this.bytes,
    required this.uint,
  });

  factory AlgodStateDelta.fromJson(Map<String, dynamic> json) =>
      _$AlgodStateDeltaFromJson(json);

  Map<String, dynamic> toJson() => _$AlgodStateDeltaToJson(this);
}
