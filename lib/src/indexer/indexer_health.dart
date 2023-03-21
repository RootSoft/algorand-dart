import 'package:algorand_dart/algorand_dart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'indexer_health.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class IndexerHealth {
  final dynamic data;
  final bool dbAvailable;
  final bool isMigrating;
  final String message;

  @JsonKey(name: 'round')
  @BigIntSerializer()
  final BigInt round;

  IndexerHealth({
    required this.dbAvailable,
    required this.isMigrating,
    required this.message,
    required this.round,
    this.data,
  });

  factory IndexerHealth.fromJson(Map<String, dynamic> json) =>
      _$IndexerHealthFromJson(json);

  Map<String, dynamic> toJson() => _$IndexerHealthToJson(this);
}
