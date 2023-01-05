import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/account/account_algod_service.dart';
import 'package:algorand_dart/src/api/account/account_indexer_service.dart';
import 'package:dio/dio.dart';

class AccountsApi {
  final AlgorandApi _api;
  final AccountAlgodService _algod;
  final AccountIndexerService _indexer;

  AccountsApi({
    required AlgorandApi api,
    required AccountAlgodService algod,
    required AccountIndexerService indexer,
  })  : _api = api,
        _algod = algod,
        _indexer = indexer;

  /// Get the account information of the given address.
  /// Given a specific account public key, this call returns the accounts
  /// status, balance and spendable amounts
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the account information.
  Future<AccountInformation> getAccountByAddress(
    String address, {
    Exclude? exclude,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _api.execute<AccountInformation>(
      () => _algod.getAccountByAddress(
        address: address,
        exclude: exclude,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// Get the account information of the given address.
  /// Given a specific account public key, this call returns the accounts
  /// status, balance and spendable amounts
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the account information.
  Future<AccountResponse> getIndexerAccountByAddress(
    String address, {
    List<Exclude>? exclude,
    bool? includeAll,
    int? round,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _api.execute<AccountResponse>(
      () => _indexer.getAccountByAddress(
        address: address,
        exclude: exclude?.map((e) => e.toJson()).join(','),
        includeAll: includeAll,
        round: round,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }
}
