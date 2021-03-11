part of 'algod_service.dart';

class _AlgodService implements AlgodService {
  _AlgodService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final dio.Dio _dio;

  String? baseUrl;

  @override
  Future<Block> getBlockForRound(int round) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/blocks/$round',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = Block.fromJson(_result.data!);
    return value;
  }
}
