part of 'asset_service.dart';

class _AssetService implements AssetService {
  _AssetService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final dio.Dio _dio;

  String? baseUrl;

  @override
  Future<SearchAssetsResponse> searchAssets(
      Map<String, dynamic> queryParameters) async {
    const _extra = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/assets',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = SearchAssetsResponse.fromJson(_result.data!);
    return value;
  }
}
