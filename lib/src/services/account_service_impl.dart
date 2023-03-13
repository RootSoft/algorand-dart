part of 'account_service.dart';

class _AccountService implements AccountService {
  _AccountService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final dio.Dio _dio;

  String? baseUrl;

  @override
  Future<SearchAccountsResponse> searchAccounts(
      Map<String, dynamic> queryParameters) async {
    const _extra = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/accounts',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = SearchAccountsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchAccountsResponse> searchAccountsWithBalance(
      int assetId, Map<String, dynamic> queryParameters) async {
    const _extra = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/assets/$assetId/balances',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = SearchAccountsResponse.fromJson(_result.data!);
    return value;
  }
}
