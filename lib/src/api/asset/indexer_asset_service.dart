import 'package:algorand_dart/src/api/responses.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'indexer_asset_service.g.dart';

@RestApi()
abstract class IndexerAssetService {
  factory IndexerAssetService(Dio dio, {String baseUrl}) = _IndexerAssetService;

  @GET('/v2/accounts/{accountId}/assets')
  Future<AssetsResponse> getAssetsByAccount({
    @Path('accountId') required String address,
    @Query('asset-id') int? assetId,
    @Query('include-all') bool? includeAll,
    @Query('limit') int? limit,
    @Query('next') String? next,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });

  @GET('/v2/accounts/{accountId}/created-assets')
  Future<CreatedAssetsResponse> getCreatedAssetsByAccount({
    @Path('accountId') required String address,
    @Query('asset-id') int? assetId,
    @Query('include-all') bool? includeAll,
    @Query('limit') int? limit,
    @Query('next') String? next,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });
}
