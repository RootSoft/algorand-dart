import 'package:json_annotation/json_annotation.dart';

enum Exclude {
  @JsonValue('all')
  all,
  @JsonValue('assets')
  assets,
  @JsonValue('created-assets')
  createdAssets,
  @JsonValue('apps-local-state')
  appsLocalState,
  @JsonValue('created-apps')
  createdApps,
  @JsonValue('none')
  none;

  String? toJson() => _$ExcludeEnumMap[this];
}

const _$ExcludeEnumMap = {
  Exclude.all: 'all',
  Exclude.assets: 'assets',
  Exclude.createdAssets: 'created-assets',
  Exclude.appsLocalState: 'apps-local-state',
  Exclude.createdApps: 'created-apps',
  Exclude.none: 'none',
};
