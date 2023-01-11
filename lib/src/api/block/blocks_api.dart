import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';

class BlocksApi {
  final BlockService _service;

  BlocksApi(BlockService service) : _service = service;

  /// Lookup a block it the given round number.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the block in the given round number.
  Future<Block> getIndexerBlockByRound(
    int round, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return _service.getIndexerBlockByRound(
        round,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }
}
