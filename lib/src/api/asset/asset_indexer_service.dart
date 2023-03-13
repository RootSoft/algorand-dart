import 'package:algorand_dart/src/api/asset/asset.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'asset_indexer_service.g.dart';

@RestApi()
abstract class AssetIndexerService {
  factory AssetIndexerService(Dio dio, {String baseUrl}) = _AssetIndexerService;

  @GET('/v2/assets/{assetId}')
  Future<AssetResponse> getAssetById({
    @Path('assetId') required int assetId,
    @Query('include-all') bool? includeAll,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });

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
