part of 'transaction_service.dart';

class _TransactionService implements TransactionService {
  _TransactionService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final dio.Dio _dio;

  String? baseUrl;

  @override
  Future<TransactionParams> getSuggestedTransactionParams() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/transactions/params',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = TransactionParams.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TransactionIdResponse> sendTransaction(Uint8List data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = Stream.fromIterable(data.map((i) => [i]));
    final _result = await _dio.request<Map<String, dynamic>>('/v2/transactions',
        queryParameters: queryParameters,
        options: dio.Options(
          method: 'POST',
          headers: <String, dynamic>{r'Content-Type': 'application/x-binary'},
          extra: _extra,
          contentType: 'application/x-binary',
        ),
        data: _data);
    final value = TransactionIdResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PendingTransactionsResponse> getPendingTransactionsByAddress(
      String address,
      {int max = 0}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'max': max};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/accounts/$address/transactions/pending',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = PendingTransactionsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PendingTransactionsResponse> getPendingTransactions(
      {int max = 0}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'max': max};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/transactions/pending',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = PendingTransactionsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PendingTransaction> getPendingTransactionById(
      String transactionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/transactions/pending/$transactionId',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = PendingTransaction.fromJson(_result.data!);
    return value;
  }
}
