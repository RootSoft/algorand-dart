import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/account/accounts_indexer_api.dart';
import 'package:algorand_dart/src/api/application/applications_indexer_api.dart';
import 'package:algorand_dart/src/api/asset/assets_indexer_api.dart';
import 'package:algorand_dart/src/api/block/blocks_indexer_api.dart';
import 'package:algorand_dart/src/api/box/boxes_indexer_api.dart';
import 'package:algorand_dart/src/api/responses/applications/application_logs_response.dart';
import 'package:algorand_dart/src/repositories/repositories.dart';
import 'package:dio/dio.dart';

/// The AlgorandIndexer provides a set of REST API calls for searching
/// blockchain Transactions, Accounts, Assets and Blocks.
///
/// Each of these calls also provides several filter parameters to support
/// refining searches.
class AlgorandIndexer {
  /// Client used to perform indexing operations.
  final IndexerRepository _indexerRepository;

  final BlocksIndexerApi _blocksApi;

  final AccountsIndexerApi _accountsApi;

  final AssetsIndexerApi _assetsApi;

  final ApplicationsIndexerApi _applicationsApi;

  final BoxesIndexerApi _boxesApi;

  AlgorandIndexer({
    required IndexerRepository indexerRepository,
    required BlocksIndexerApi blocksApi,
    required AccountsIndexerApi accountsApi,
    required AssetsIndexerApi assetsApi,
    required ApplicationsIndexerApi applicationsApi,
    required BoxesIndexerApi boxesApi,
  })  : _indexerRepository = indexerRepository,
        _blocksApi = blocksApi,
        _accountsApi = accountsApi,
        _assetsApi = assetsApi,
        _applicationsApi = applicationsApi,
        _boxesApi = boxesApi;

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

  /// Lookup account information by a given account address.
  ///
  /// If [throwOnEmptyBalance] is true, an [AlgorandException] will be thrown,
  /// otherwise an empty account will be returned.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error, or an invalid
  /// address is passed.
  /// Returns the account information for the given account id.
  Future<AccountResponse> getAccountByAddress(
    String address, {
    bool throwOnEmptyBalance = true,
    int? round,
    List<Exclude>? exclude,
    bool? includeAll,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _accountsApi.getAccountByAddress(
        address,
        round: round,
        exclude: exclude,
        includeAll: includeAll,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } on AlgorandException catch (ex) {
      final statusCode = ex.statusCode;
      if (statusCode == 404 && !throwOnEmptyBalance) {
        return Future.value(
          AccountResponse(
            currentRound: 0,
            account: AccountInformation.empty(address),
          ),
        );
      }

      rethrow;
    }
  }

  /// Lookup asset information by a given asset id.
  ///
  /// Include all items including closed accounts, deleted applications,
  /// destroyed assets, opted-out asset holdings, and closed-out application
  /// localstates.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the asset information for the given asset id.
  Future<AssetResponse> getAssetById(
    int assetId, {
    bool? includeAll,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _assetsApi.getAssetById(
      assetId,
      includeAll: includeAll,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Lookup application information by a given id.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the application information for the given application id.
  Future<ApplicationResponse> getApplicationById(
    int applicationId, {
    bool? includeAll,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _applicationsApi.getApplicationById(
      applicationId,
      includeAll: includeAll,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Lookup application information by a given id.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the application information for the given application id.
  Future<ApplicationLogsResponse> getApplicationLogsById(
    int applicationId, {
    int? limit,
    int? maxRound,
    int? minRound,
    String? next,
    String? senderAddress,
    String? transactionId,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _applicationsApi.getApplicationLogsById(
      applicationId,
      limit: limit,
      maxRound: maxRound,
      minRound: minRound,
      next: next,
      senderAddress: senderAddress,
      transactionId: transactionId,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
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
  Future<Block> getBlockByRound(
    BigInt round, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _blocksApi.getBlockByRound(
      round,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Get box information for a given application.
  ///
  /// Given an application ID and box name, it returns the box name and value
  /// (each base64 encoded).
  /// Box names must be in the goal app call arg encoding form 'encoding:value'.
  /// For ints, use the form 'int:1234'.
  /// For raw bytes, use the form 'b64:A=='.
  /// For printable strings, use the form 'str:hello'.
  /// For addresses, use the form 'addr:XYZ...'.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the block in the given round number.
  Future<BoxResponse> getBox(
    int applicationId,
    String name, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _boxesApi.getBoxByApplicationId(
      applicationId,
      name,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Get all box names for a given application.
  ///
  /// Given an application ID, return all Box names.
  /// No particular ordering is guaranteed.
  /// Request fails when client or server-side configured limits prevent
  /// returning all Box names.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the block in the given round number.
  Future<List<BoxDescriptor>> getBoxNames(
    int applicationId, {
    int? perPage,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _boxesApi.getBoxNamesByApplicationId(
      applicationId,
      limit: perPage,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
