import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'asset_algod_service.g.dart';

@RestApi()
abstract class AssetAlgodService {
  factory AssetAlgodService(Dio dio, {String baseUrl}) = _AssetAlgodService;
}
