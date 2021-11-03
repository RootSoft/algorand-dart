import 'package:json_annotation/json_annotation.dart';

part 'application_log_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class ApplicationLogData {
  /// Logs for the application being executed by the transaction.
  @JsonKey(name: 'logs', defaultValue: [])
  final List<String> logs;

  /// The transaction id.
  @JsonKey(name: 'txid')
  final String? txId;

  ApplicationLogData({
    required this.logs,
    this.txId,
  });

  factory ApplicationLogData.fromJson(Map<String, dynamic> json) =>
      _$ApplicationLogDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationLogDataToJson(this);
}
