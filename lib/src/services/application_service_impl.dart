part of 'application_service.dart';

class _ApplicationService implements ApplicationService {
  _ApplicationService(this._dio, {this.baseUrl}) {
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
        options: dio.Options(
          method: 'POST',
          headers: <String, dynamic>{r'Content-Type': 'application/x-binary'},
          extra: _extra,
          contentType: 'application/x-binary',
        ),
        data: sourceCode);
    final value = TealCompilation.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DryRunResponse> dryrun(Uint8List request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = Stream.fromIterable(request.map((i) => [i]));
    final _result = await _dio.request<Map<String, dynamic>>('/v2/teal/dryrun',
        queryParameters: queryParameters,
        options: dio.Options(
          method: 'POST',
          headers: <String, dynamic>{r'Content-Type': 'application/x-binary'},
          extra: _extra,
          contentType: 'application/x-binary',
        ),
        data: _data);
    final value = DryRunResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchApplicationsResponse> searchApplications(
    Map<String, dynamic> queryParameters,
  ) async {
    const _extra = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
      '/v2/applications',
      queryParameters: queryParameters,
      options: dio.Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = SearchApplicationsResponse.fromJson(_result.data!);
    return value;
  }
}
