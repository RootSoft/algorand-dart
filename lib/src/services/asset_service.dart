import 'package:algorand_dart/src/api/responses.dart';
import 'package:dio/dio.dart' as dio;

part 'asset_service_impl.dart';

//@RestApi()
abstract class AssetService {
  factory AssetService(dio.Dio dio, {String baseUrl}) = _AssetService;

  //@GET("/v2/assets")
  Future<SearchAssetsResponse> searchAssets(
    Map<String, dynamic> queryParameters,
  );
}
