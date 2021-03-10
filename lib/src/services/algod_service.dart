import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/services/api_service.dart';
import 'package:dio/dio.dart' as dio;

part 'algod_service_impl.dart';

//@RestApi()
abstract class AlgodService extends ApiService {
  factory AlgodService(dio.Dio dio, {String baseUrl}) = _AlgodService;

  //@GET("/v2/blocks/{round}")
  Future<Block> getBlockForRound(
    /*@Path('round')*/ int round,
  );
}
