part of 'application_service.dart';

class _ApplicationService implements ApplicationService {
  _ApplicationService(this._dio, {this.baseUrl = null}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final dio.Dio _dio;

  String? baseUrl;

  @override
  Future<TealCompilation> compileTEAL(String sourceCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    //final _data = Stream.fromIterable(sourceCode.map((i) => [i]));
    final _result = await _dio.request<Map<String, dynamic>>('/v2/teal/compile',
        queryParameters: queryParameters,
        options: dio.RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Content-Type': 'application/x-binary'},
            extra: _extra,
            contentType: 'application/x-binary',
            baseUrl: baseUrl),
        data: sourceCode);
    final value = TealCompilation.fromJson(_result.data);
    return value;
  }
}
