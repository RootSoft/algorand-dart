import 'package:algorand_dart/src/api/block/block.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'algod_block_service.g.dart';

@RestApi()
abstract class AlgodBlockService {
  factory AlgodBlockService(Dio dio, {String baseUrl}) = _AlgodBlockService;

  @GET('/v2/blocks/{round}')
  Future<BlockResponse> getBlockByRound({
    @Path('round') required int round,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });
}
