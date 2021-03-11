import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/exceptions/exceptions.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/encoders/msgpack_encoder.dart';
import 'package:crypto/crypto.dart';

/// An Atomic Transfer means that transactions that are part of the transfer
/// either all succeed or all fail.
///
/// Atomic transfers allow complete strangers to trade assets without the
/// need for a trusted intermediary, all while guaranteeing that each party
/// will receive what they agreed to.
///
/// On Algorand, atomic transfers are implemented as irreducible batch
/// operations, where a group of transactions are submitted as a unit and all
/// transactions in the batch either pass or fail.
///
/// This also eliminates the need for more complex solutions like
/// hashed timelock contracts that are implemented on other blockchains.
/// An atomic transfer on Algorand is confirmed in less than 5 seconds,
/// just like any other transaction.
///
/// Transactions can contain Algos or Algorand Standard Assets and may also be
/// governed by Algorand Smart Contracts.
class AtomicTransfer {
  /// The prefix for a transaction group.
  static const TG_PREFIX = 'TG';

  /// The maximum allowed number of transactions in an atomic transfer.
  static const MAX_TRANSACTION_GROUP_SIZE = 16;

  /// Group a list of transactions and assign them with a group id.
  ///
  /// An optional sender address can be specified which transaction return.
  /// Throws an [AlgorandException] when unable to calculate a group id.
  static List<RawTransaction> group(List<RawTransaction> transactions,
      [Address? address]) {
    // Calculate the group id and assign to each transaction
    final groupId = computeGroupId(transactions);
    final groupedTransactions = <RawTransaction>[];
    for (var transaction in transactions) {
      if (address == null || address == transaction.sender) {
        transaction.assignGroupId(groupId);
        groupedTransactions.add(transaction);
      }
    }

    return groupedTransactions;
  }

  /// Compute the group id of the transactions.
  static Uint8List computeGroupId(List<RawTransaction> transactions) {
    if (transactions.isEmpty) {
      throw AlgorandException(message: 'Empty transaction list');
    }

    if (transactions.length > MAX_TRANSACTION_GROUP_SIZE) {
      throw AlgorandException(
          message: 'Max. group size is $MAX_TRANSACTION_GROUP_SIZE');
    }

    // Calculate the transaction ids for every transaction
    final transactionIds = <Uint8List>[];
    for (var transaction in transactions) {
      transactionIds.add(transaction.rawId);
    }

    // Encode the transaction
    final encodedTx = Encoder.encodeMessagePack({'txlist': transactionIds});

    // Prepend with group transaction prefix
    final tgBytes = utf8.encode(TG_PREFIX);

    // Merge the byte arrays & hash
    return Uint8List.fromList(
        sha512256.convert([...tgBytes, ...encodedTx]).bytes);
  }
}
