import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/services/services.dart';
import 'package:dio/dio.dart';

class IndexerRepository {
  /// Service used to perform indexing operations
  final IndexerService indexerService;

  /// Service used to fetch accounts
  final AccountService accountService;

  /// Service used to fetch assets
  final AssetService assetService;

  /// Service used to fetch assets
  final ApplicationService applicationService;

  IndexerRepository({
    required this.indexerService,
    required this.accountService,
    required this.assetService,
    required this.applicationService,
  });

  /// Check if the indexer is healthy.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the filtered transactions.
  Future<IndexerHealth> health() async {
    try {
      return await indexerService.health();
    } on DioException catch (ex) {
      throw AlgorandException(message: ex.message!, cause: ex);
    }
  }

  /// Search transactions using the indexer.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the filtered transactions.
  Future<SearchTransactionsResponse> searchTransactions(
    Map<String, dynamic> queryParams,
  ) async {
    try {
      // Find transactions for account
      if (queryParams.containsKey(TransactionQueryBuilder.KEY_ACCOUNT_ID)) {
        final accountId =
            queryParams[TransactionQueryBuilder.KEY_ACCOUNT_ID] as String;

        // Remove the query param
        queryParams.remove(TransactionQueryBuilder.KEY_ACCOUNT_ID);

        return await indexerService.searchTransactionsForAccount(
          accountId,
          queryParams,
        );
      }

      // Find transactions for asset
      if (queryParams.containsKey(TransactionQueryBuilder.KEY_ASSET_ID)) {
        final assetId =
            queryParams[TransactionQueryBuilder.KEY_ASSET_ID] as int;

        // Remove the query param
        queryParams.remove(TransactionQueryBuilder.KEY_ASSET_ID);

        return await indexerService.searchTransactionsForAsset(
          assetId,
          queryParams,
        );
      }

      return await indexerService.searchTransactions(queryParams);
    } on DioException catch (ex) {
      throw AlgorandException(message: ex.message!, cause: ex);
    }
  }

  /// Search assets using the indexer.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the filtered assets.
  Future<SearchAssetsResponse> searchAssets(
    Map<String, dynamic> queryParams,
  ) async {
    try {
      return await assetService.searchAssets(queryParams);
    } on DioException catch (ex) {
      throw AlgorandException(message: ex.message!, cause: ex);
    }
  }

  /// Search accounts using the indexer.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the filtered accounts.
  Future<SearchAccountsResponse> searchAccounts(
    Map<String, dynamic> queryParams,
  ) async {
    try {
      if (queryParams.containsKey(AccountQueryBuilder.KEY_BALANCE_ID)) {
        final assetId = queryParams[AccountQueryBuilder.KEY_BALANCE_ID] as int;

        // Remove the query param
        queryParams.remove(AccountQueryBuilder.KEY_BALANCE_ID);

        return await accountService.searchAccountsWithBalance(
          assetId,
          queryParams,
        );
      }

      return await accountService.searchAccounts(queryParams);
    } on DioException catch (ex) {
      throw AlgorandException(message: ex.message!, cause: ex);
    }
  }

  /// Search accounts using the indexer.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the filtered accounts.
  Future<SearchApplicationsResponse> searchApplications(
    Map<String, dynamic> queryParams,
  ) async {
    try {
      return await applicationService.searchApplications(queryParams);
    } on DioException catch (ex) {
      throw AlgorandException(message: ex.message!, cause: ex);
    }
  }

  /// Lookup transaction information by a given transaction id.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the transaction information for the given id.
  Future<TransactionResponse> getTransactionById(String transactionId) async {
    try {
      return await indexerService.getTransactionById(transactionId);
    } on DioException catch (ex) {
      throw AlgorandException(message: ex.message!, cause: ex);
    }
  }
}
