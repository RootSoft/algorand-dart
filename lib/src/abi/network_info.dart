import 'package:json_annotation/json_annotation.dart';

part 'network_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class NetworkInfo {
  @JsonKey(name: 'appID')
  final int applicationId;

  NetworkInfo({
    required this.applicationId,
  });

  factory NetworkInfo.fromJson(Map<String, dynamic> json) =>
      _$NetworkInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkInfoToJson(this);
}
