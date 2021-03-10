import 'package:algorand_dart/src/api/responses.dart';
import 'package:algorand_dart/src/services/api_service.dart';
import 'package:dio/dio.dart' as dio;

part 'asset_service_impl.dart';

//@RestApi()
abstract class AssetService extends ApiService {
  factory AssetService(dio.Dio dio, {String baseUrl}) = _AssetService;

  //@GET("/v2/assets")
  Future<SearchAssetsResponse> searchAssets(
    Map<String, dynamic> queryParameters,
  );

  //@GET("/v2/assets/{assetId}")
  Future<AssetResponse> getAssetById(/*@Path('assetId')*/ int assetId);
}
