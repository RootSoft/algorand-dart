import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'block_algod_service.g.dart';

@RestApi()
abstract class BlockAlgodService {
  factory BlockAlgodService(Dio dio, {String baseUrl}) = _BlockAlgodService;

  @GET('/v2/blocks/{round}')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getBlockByRound({
    @Path('round') required BigInt round,
    @Query('format') String format = 'msgpack',
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });
}
