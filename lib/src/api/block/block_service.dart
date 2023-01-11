import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';

class BlockService {
  final AlgodBlockService _algod;
  final IndexerBlockService _indexer;

  BlockService({
    required AlgodBlockService algod,
    required IndexerBlockService indexer,
  })  : _algod = algod,
        _indexer = indexer;

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
    return _indexer.getBlockByRound(
      round: round,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
