part of 'node_service.dart';

class _NodeService implements NodeService {
  _NodeService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<String> genesis() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<String>('/genesis',
        queryParameters: queryParameters,
        options: Options(
          method: 'GET',
          headers: <String, dynamic>{},
          extra: _extra,
        ),
        data: _data);
    final value = _result.data!;
    return value;
  }

  @override
  Future<void> health() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    await _dio.request<void>('/health',
        queryParameters: queryParameters,
        options: Options(
          method: 'GET',
          headers: <String, dynamic>{},
          extra: _extra,
        ),
        data: _data);
    return null;
  }

  @override
  Future<NodeStatus> status() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/status',
      queryParameters: queryParameters,
      options: Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = NodeStatus.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NodeStatus> statusAfterRound(roundId) async {
    ArgumentError.checkNotNull(roundId, 'roundId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/status/wait-for-block-after/$roundId',
      queryParameters: queryParameters,
      options: Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = NodeStatus.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LedgerSupply> supply() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/ledger/supply',
      queryParameters: queryParameters,
      options: Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = LedgerSupply.fromJson(_result.data!);
    return value;
  }
}
