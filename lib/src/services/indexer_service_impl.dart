part of 'indexer_service.dart';

class _IndexerService implements IndexerService {
  _IndexerService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final dio.Dio _dio;

  String? baseUrl;

  @override
  Future<IndexerHealth> health() async {
    const _extra = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/health',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = IndexerHealth.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchTransactionsResponse> searchTransactions(
    Map<String, dynamic> queryParameters,
  ) async {
    const _extra = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/transactions',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = SearchTransactionsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchTransactionsResponse> searchTransactionsForAccount(
    String accountId,
    Map<String, dynamic> queryParameters,
  ) async {
    const _extra = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/accounts/$accountId/transactions',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = SearchTransactionsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchTransactionsResponse> searchTransactionsForAsset(
    int assetId,
    Map<String, dynamic> queryParameters,
  ) async {
    const _extra = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/assets/$assetId/transactions',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = SearchTransactionsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TransactionResponse> getTransactionById(String transactionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/transactions/$transactionId',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = TransactionResponse.fromJson(_result.data!);
    return value;
  }
}
