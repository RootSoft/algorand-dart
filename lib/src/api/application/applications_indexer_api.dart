import 'package:algorand_dart/src/api/api.dart';
import 'package:algorand_dart/src/api/application/application_indexer_service.dart';
import 'package:dio/dio.dart';

class ApplicationsIndexerApi {
  final AlgorandApi _api;
  final ApplicationIndexerService _service;

  ApplicationsIndexerApi({
    required AlgorandApi api,
    required ApplicationIndexerService service,
  })  : _api = api,
        _service = service;

  /// Lookup created applications information by a given account id.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the created applications information for the given account id.
  Future<List<Application>> getCreatedApplicationsByAddress(
    String address, {
    int? applicationId,
    bool? includeAll,
    int? perPage,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _api.paginate<Application>((nextToken) async {
      final response = await _service.getApplicationsByAccount(
        address: address,
        applicationId: applicationId,
        includeAll: includeAll,
        limit: perPage,
        next: nextToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return PaginatedResult(
        nextToken: response.nextToken,
        items: response.applications,
      );
    });
  }
}
