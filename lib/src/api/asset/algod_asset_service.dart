import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'algod_asset_service.g.dart';

@RestApi()
abstract class AlgodAssetService {
  factory AlgodAssetService(Dio dio, {String baseUrl}) = _AlgodAssetService;
}
