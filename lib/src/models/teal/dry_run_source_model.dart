import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dry_run_source_model.g.dart';

/// DryrunSource is TEAL source text that gets uploaded, compiled, and inserted
/// into transactions or application state.
@JsonSerializable(fieldRename: FieldRename.kebab)
class DryRunSource extends Equatable {
  @JsonKey(name: 'app-index')
  final int? appIndex;

  @JsonKey(name: 'field-name')
  final String? fieldName;

  @JsonKey(name: 'source')
  final String? source;

  @JsonKey(name: 'txn-index')
  final int? txnIndex;

  DryRunSource({
    this.appIndex,
    this.fieldName,
    this.source,
    this.txnIndex,
  });

  factory DryRunSource.fromJson(Map<String, dynamic> json) =>
      _$DryRunSourceFromJson(json);

  Map<String, dynamic> toJson() => _$DryRunSourceToJson(this);

  @override
  List<Object?> get props => [];
}
