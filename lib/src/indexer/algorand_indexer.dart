import 'package:algorand_dart/src/api/responses.dart';
import 'package:algorand_dart/src/api/responses/applications/application_logs_response.dart';
import 'package:algorand_dart/src/indexer/builders/application_query_builder.dart';
import 'package:algorand_dart/src/indexer/builders/query_builders.dart';
import 'package:algorand_dart/src/indexer/indexer_health.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/repositories/repositories.dart';

/// The AlgorandIndexer provides a set of REST API calls for searching
/// blockchain Transactions, Accounts, Assets and Blocks.
///
/// Each of these calls also provides several filter parameters to support
/// refining searches.
class AlgorandIndexer {
  /// Client used to perform indexing operations.
  final IndexerRepository _indexerRepository;

  AlgorandIndexer({required IndexerRepository indexerRepository})
      : _indexerRepository = indexerRepository;

  /// Get the health status of the indexer.
  ///
  /// Throws [AlgorandException] if unable to fetch the health status.
  Future<IndexerHealth> health() async {
    return _indexerRepository.health();
  }

  /// Allow searching all transactions that have occurred on the blockchain.
  /// This call contains many parameters to refine the search for specific
  /// values.
  TransactionQueryBuilder transactions() {
    return TransactionQueryBuilder(
      indexerRepository: _indexerRepository,
    );
  }

  /// Allow searching all assets that have occurred on the blockchain.
  /// This call contains many parameters to refine the search for specific
  /// values.
  AssetQueryBuilder assets() {
    return AssetQueryBuilder(
      indexerRepository: _indexerRepository,
    );
  }

  /// Allow searching all accounts that have occurred on the blockchain.
  /// This call contains many parameters to refine the search for specific
  /// values.
  AccountQueryBuilder accounts() {
    return AccountQueryBuilder(
      indexerRepository: _indexerRepository,
    );
  }

  /// Allow searching all applications on the blockchain.
  /// This call contains many parameters to refine the search for specific
  /// values.
  ApplicationQueryBuilder applications() {
    return ApplicationQueryBuilder(
      indexerRepository: _indexerRepository,
    );
  }

  /// Lookup account information by a given account id.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the account information for the given account id.
  Future<AccountResponse> getAccountById(
    String accountId, {
    int? round,
  }) async {
    return _indexerRepository.getAccountById(accountId, round: round);
  }

  /// Lookup asset information by a given asset id.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the asset information for the given asset id.
  Future<AssetResponse> getAssetById(int assetId) async {
    return _indexerRepository.getAssetById(assetId);
  }

  /// Lookup application information by a given id.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the application information for the given application id.
  Future<ApplicationResponse> getApplicationById(int applicationId) async {
    return _indexerRepository.getApplicationById(applicationId);
  }

  /// Lookup application information by a given id.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the application information for the given application id.
  Future<ApplicationLogsResponse> getApplicationLogsById(
    int applicationId, {
    Map<String, dynamic> queryParameters = const {},
  }) async {
    return _indexerRepository.getApplicationLogsById(
      applicationId,
      queryParameters: queryParameters,
    );
  }

  /// Lookup transaction information by a given transaction id.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the transaction information for the given id.
  Future<TransactionResponse> getTransactionById(String transactionId) async {
    return _indexerRepository.getTransactionById(transactionId);
  }

  /// Lookup a block it the given round number.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the block in the given round number.
  Future<Block> getBlockByRound(int round) async {
    return _indexerRepository.getBlockByRound(round);
  }
}
