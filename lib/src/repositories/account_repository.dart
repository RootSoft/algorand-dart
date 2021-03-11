import 'package:algorand_dart/src/exceptions/algorand_exception.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/services/services.dart';
import 'package:dio/dio.dart';

class AccountRepository {
  final AccountService accountService;

  AccountRepository({
    required this.accountService,
  });

  /// Get the account information of the given address.
  /// Given a specific account public key, this call returns the accounts
  /// status, balance and spendable amounts
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<AccountInformation> getAccountByAddress(String address) async {
    try {
      return await accountService.getAccountByAddress(address);
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }
}
