import 'dart:async';
import 'dart:typed_data';

import 'package:algorand_dart/src/api/responses.dart';
import 'package:algorand_dart/src/exceptions/algorand_exception.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/services/services.dart';
import 'package:algorand_dart/src/services/transaction_service.dart';
import 'package:algorand_dart/src/utils/encoders/msgpack_encoder.dart';
import 'package:buffer/buffer.dart';
import 'package:dio/dio.dart';

class TransactionRepository {
  final NodeService nodeService;
  final TransactionService transactionService;

  TransactionRepository({
    required this.nodeService,
    required this.transactionService,
  });

  /// Gets the suggested transaction parameters.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the suggested transaction parameters.
  Future<TransactionParams> getSuggestedTransactionParams() async {
    try {
      return await transactionService.getSuggestedTransactionParams();
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Broadcast a new (signed) raw transaction on the network.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<String> sendRawTransaction(
    Uint8List transaction, {
    bool waitForConfirmation = false,
    int timeout = 5,
  }) async {
    try {
      final response = await transactionService.sendTransaction(transaction);

      if (!waitForConfirmation) return response.transactionId;

      // Wait for confirmation
      await this.waitForConfirmation(response.transactionId, timeout: timeout);

      return response.transactionId;
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Group a list of (signed) transactions and broadcast it on the network.
  /// This is mostly used for atomic transfers.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<String> sendRawTransactions(
    List<Uint8List> transactions, {
    bool waitForConfirmation = false,
    int timeout = 5,
  }) async {
    final txWriter = ByteDataWriter();
    for (var transaction in transactions) {
      txWriter.write(transaction);
    }

    try {
      final response =
          await transactionService.sendTransaction(txWriter.toBytes());
      if (!waitForConfirmation) return response.transactionId;

      // Wait for confirmation
      await this.waitForConfirmation(response.transactionId, timeout: timeout);

      return response.transactionId;
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Broadcast a new (signed) transaction on the network.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<String> sendTransaction(
    SignedTransaction transaction, {
    bool waitForConfirmation = false,
    int timeout = 5,
  }) async {
    try {
      final encodedTxBytes =
          Encoder.encodeMessagePack(transaction.toMessagePack());
      final response = await transactionService.sendTransaction(encodedTxBytes);

      if (!waitForConfirmation) return response.transactionId;

      // Wait for confirmation
      await this.waitForConfirmation(response.transactionId, timeout: timeout);

      return response.transactionId;
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Group a list of (signed) transactions and broadcast it on the network.
  /// This is mostly used for atomic transfers.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<String> sendTransactions(
    List<SignedTransaction> transactions, {
    bool waitForConfirmation = false,
    int timeout = 5,
  }) async {
    final txWriter = ByteDataWriter();
    for (var transaction in transactions) {
      txWriter.write(Encoder.encodeMessagePack(transaction.toMessagePack()));
    }

    try {
      final data = txWriter.toBytes();
      final response = await transactionService.sendTransaction(data);
      if (!waitForConfirmation) return response.transactionId;

      // Wait for confirmation
      await this.waitForConfirmation(response.transactionId, timeout: timeout);

      return response.transactionId;
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Get the list of pending transactions by address, sorted by priority,
  /// in decreasing order, truncated at the end at MAX.
  ///
  /// If MAX = 0, returns all pending transactions.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the pending transactions for the address.
  Future<PendingTransactionsResponse> getPendingTransactionsByAddress(
    String address, {
    int max = 0,
  }) async {
    try {
      return await transactionService.getPendingTransactionsByAddress(address,
          max: max);
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Get the list of pending transactions, sorted by priority,
  /// in decreasing order, truncated at the end at MAX.
  ///
  /// If MAX = 0, returns all pending transactions.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the pending transactions.
  Future<PendingTransactionsResponse> getPendingTransactions({
    int max = 0,
  }) async {
    try {
      return await transactionService.getPendingTransactions(max: max);
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Get a specific pending transaction.
  ///
  /// Given a transaction id of a recently submitted transaction, it returns
  /// information about it.
  ///
  /// There are several cases when this might succeed:
  /// - transaction committed (committed round > 0)
  /// - transaction still in the pool (committed round = 0, pool error = "")
  /// - transaction removed from pool due to error
  /// (committed round = 0, pool error != "")
  ///
  /// Or the transaction may have happened sufficiently long ago that the node
  /// no longer remembers it, and this will return an error.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the pending transaction.
  Future<PendingTransaction> getPendingTransactionById(
    String transactionId,
  ) async {
    try {
      return await transactionService.getPendingTransactionById(transactionId);
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Utility function to wait on a transaction to be confirmed.
  /// The timeout parameter indicates how many rounds do you wish to check
  /// pending transactions for.
  ///
  /// On Algorand, transactions are final as soon as they are incorporated into
  /// a block and blocks are produced, on average, every 5 seconds.
  ///
  /// This means that transactions are confirmed, on average, in 5 seconds
  Future<PendingTransaction> waitForConfirmation(
    String transactionId, {
    int timeout = 5,
  }) async {
    try {
      final status = await nodeService.status();
      final startRound = status.lastRound + 1;
      var currentRound = startRound;

      while (currentRound < (startRound + timeout)) {
        final pending = await getPendingTransactionById(transactionId);
        final confirmedRound = pending.confirmedRound;
        if (confirmedRound != null && confirmedRound > 0) {
          return pending;
        }

        await nodeService.statusAfterRound(currentRound);
        currentRound++;
      }
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }

    throw AlgorandException(
      message: 'Transaction not confirmed after $timeout rounds!',
    );
  }
}
