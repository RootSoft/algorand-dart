// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_algod_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _AccountAlgodService implements AccountAlgodService {
  _AccountAlgodService(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<AccountInformation> getAccountByAddress({
    required address,
    exclude,
    cancelToken,
    onSendProgress,
    onReceiveProgress,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'exclude': exclude?.toJson()};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AccountInformation>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/v2/accounts/${address}',
              queryParameters: queryParameters,
              data: _data,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AccountInformation.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
