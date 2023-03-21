import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/exceptions/exceptions.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/fee_calculator.dart';

abstract class RawTransactionBuilder<T extends RawTransaction> {
  /// Paid by the sender to the FeeSink to prevent denial-of-service.
  /// The minimum fee on Algorand is currently 1000 microAlgos.
  /// This field cannot be combined with flat fee.
  BigInt _fee = RawTransaction.MIN_TX_FEE_UALGOS;

  /// Paid by the sender to the FeeSink to prevent denial-of-service.
  /// The minimum fee on Algorand is currently 1000 microAlgos.
  /// This field cannot be combined with flat fee.
  BigInt? suggestedFeePerByte;

  /// This value will be used for the transaction fee, or 1000,
  /// whichever is higher.
  ///
  /// This field cannot be combined with fee.
  /// The minimum fee on Algorand is currently 1000 microAlgos.
  BigInt? flatFee;

  /// The first round for when the transaction is valid.
  /// If the transaction is sent prior to this round it will be rejected by
  /// the network.
  BigInt? firstValid;

  /// The hash of the genesis block of the network for which the transaction
  /// is valid. See the genesis hash for MainNet, TestNet, and BetaNet.
  Uint8List? genesisHash;

  /// The ending round for which the transaction is valid.
  /// After this round, the transaction will be rejected by the network.
  BigInt? lastValid;

  /// The address of the account that pays the fee and amount.
  Address? sender;

  /// Specifies the type of transaction.
  /// This value is automatically generated using any of the developer tools.
  TransactionType type;

  /// The human-readable string that identifies the network for the transaction.
  /// The genesis ID is found in the genesis block.
  ///
  /// See the genesis ID for MainNet, TestNet, and BetaNet.
  String? genesisId;

  /// The group specifies that the transaction is part of a group and, if so,
  /// specifies the hash of the transaction group.
  ///
  /// Assign a group ID to a transaction through the workflow described in
  /// the Atomic Transfers Guide.
  Uint8List? group;

  /// A lease enforces mutual exclusion of transactions.
  /// If this field is nonzero, then once the transaction is confirmed,
  /// it acquires the lease identified by the (Sender, Lease) pair of the
  /// transaction until the LastValid round passes.
  ///
  /// While this transaction possesses the lease, no other transaction
  /// specifying this lease can be confirmed.
  ///
  /// A lease is often used in the context of Algorand Smart Contracts to
  /// prevent replay attacks.
  ///
  /// Read more about Algorand Smart Contracts and see the
  /// Delegate Key Registration TEAL template for an example implementation of
  /// leases.
  ///
  /// Leases can also be used to safeguard against unintended duplicate spends.
  Uint8List? lease;

  /// Any data up to 1000 bytes.
  Uint8List? note;

  /// Specifies the authorized address.
  /// This address will be used to authorize all future transactions.
  Address? rekeyTo;

  RawTransactionBuilder(this.type);

  set noteText(String? data) {
    if (data == null) {
      return;
    }

    note = Uint8List.fromList(utf8.encode(data));
  }

  set noteB64(String data) {
    note = base64Decode(data);
  }

  set genesisHashB64(String data) {
    genesisHash = base64Decode(data);
  }

  set leaseB64(String data) {
    lease = base64Decode(data);
  }

  /// The suggested params to use
  set suggestedParams(TransactionParams value) {
    _fee = value.fee;
    genesisId = value.genesisId;
    genesisHash = value.genesisHash;
    firstValid = value.lastRound;
    lastValid = value.lastRound + BigInt.from(1000);
  }

  BigInt get fee => _fee;

  Future<int> estimatedTransactionSize();

  Future<T?> build() async {
    final flatFee = this.flatFee;
    final suggestedFeePerByte = this.suggestedFeePerByte;

    // Fee validation
    if (suggestedFeePerByte != null && flatFee != null) {
      throw AlgorandException(message: 'Cannot set both fee and flat fee.');
    }

    if (suggestedFeePerByte != null) {
      // Set the fee to calculate correct estimated transaction size
      // see setFeeByFeePerByte in Java
      _fee = suggestedFeePerByte;

      final transactionSize = await estimatedTransactionSize();

      _fee = await FeeCalculator.calculateTransactionFee(
        transactionSize,
        suggestedFeePerByte,
      );
    } else if (flatFee != null) {
      _fee = flatFee;
    }

    // Ensure min fee
    if (fee < RawTransaction.MIN_TX_FEE_UALGOS) {
      _fee = RawTransaction.MIN_TX_FEE_UALGOS;
    }

    return null;
  }
}
