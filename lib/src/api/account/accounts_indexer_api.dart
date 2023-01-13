import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/account/account_indexer_service.dart';
import 'package:dio/dio.dart';

class AccountsIndexerApi {
  final AlgorandApi _api;
  final AccountIndexerService _service;

  AccountsIndexerApi({
    required AlgorandApi api,
    required AccountIndexerService service,
  })  : _api = api,
        _service = service;

  /// Get the account information of the given address.
  /// Given a specific account public key, this call returns the accounts
  /// status, balance and spendable amounts
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the account information.
  Future<AccountResponse> getAccountByAddress(
    String address, {
    List<Exclude>? exclude,
    bool? includeAll,
    int? round,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _api.execute<AccountResponse>(
      () => _service.getAccountByAddress(
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
