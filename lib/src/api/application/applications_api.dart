import 'package:algorand_dart/src/api/api.dart';
import 'package:algorand_dart/src/api/application/indexer_application_service.dart';
import 'package:dio/dio.dart';

class ApplicationsApi {
  final AlgorandApi _api;
  //final AlgodAssetService _algod;
  final IndexerApplicationService _indexer;

  ApplicationsApi({
    required AlgorandApi api,
    required IndexerApplicationService indexer,
  })  : _api = api,
        _indexer = indexer;

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
      final response = await _indexer.getApplicationsByAccount(
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
