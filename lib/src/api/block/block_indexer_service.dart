import 'package:algorand_dart/src/api/block/block_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'block_indexer_service.g.dart';

@RestApi()
abstract class BlockIndexerService {
  factory BlockIndexerService(Dio dio, {String baseUrl}) = _IndexerBlockService;

  @GET('/v2/blocks/{round}')
  Future<Block> getBlockByRound({
    @Path('round') required int round,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });
}
