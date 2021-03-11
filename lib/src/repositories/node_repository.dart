import 'package:algorand_dart/src/exceptions/algorand_exception.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/services/node_service.dart';
import 'package:dio/dio.dart';

class NodeRepository {
  final NodeService service;

  NodeRepository({required this.service});

  /// Gets the genesis information.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the entire genesis file in json.
  Future<String> genesis() async {
    try {
      final genesis = await service.genesis();
      return genesis;
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Checks if the node is healthy.
  ///
  /// Returns true if the node is healthy.
  Future<bool> health() async {
    try {
      await service.health();
      return true;
    } on DioError {
      return false;
    }
  }

  /// Gets the current node status.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the current node status.
  Future<NodeStatus> status() async {
    try {
      return await service.status();
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Gets the node status after waiting for the given round.
  ///
  /// Waits for a block to appear after round {round} and returns the node's
  /// status at the time.
  ///
  /// round is the round to wait until returning status
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the current node status.
  Future<NodeStatus> statusAfterRound(int round) async {
    try {
      return await service.statusAfterRound(round);
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Get the current supply reported by the ledger.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the current supply reported by the ledger.
  Future<LedgerSupply> supply() async {
    try {
      return await service.supply();
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }
}
