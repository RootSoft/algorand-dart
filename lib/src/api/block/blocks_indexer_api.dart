import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/block/block_indexer_service.dart';
import 'package:dio/dio.dart';

class BlocksIndexerApi {
  final AlgorandApi _api;
  final BlockIndexerService _service;

  BlocksIndexerApi({
    required AlgorandApi api,
    required BlockIndexerService service,
  })  : _api = api,
        _service = service;

  /// Lookup a block it the given round number.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the block in the given round number.
  Future<Block> getBlockByRound(
    BigInt round, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _api.execute<Block>(
      () async {
        return _service.getBlockByRound(
          round: round,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
      },
    );
  }
}
