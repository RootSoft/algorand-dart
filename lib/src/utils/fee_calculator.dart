import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/encoders/msgpack_encoder.dart';

class FeeCalculator {
  /// Calculate the total fee for a transaction.
  /// This value is multiplied by the estimated size of the transaction in
  /// bytes to determine the total transaction fee.
  ///
  /// If the result is less than the minimum fee, the minimum fee is used
  /// instead.
  static Future<BigInt> calculateFeePerByte(
      RawTransaction transaction, BigInt suggestedFeePerByte) async {
    final transactionSize = await estimateTransactionSize(transaction);
    var transactionFee = suggestedFeePerByte * BigInt.from(transactionSize);

    // Check min fee
    if (transactionFee < RawTransaction.MIN_TX_FEE_UALGOS) {
      transactionFee = RawTransaction.MIN_TX_FEE_UALGOS;
    }

    return transactionFee;
  }

  /// Calculate the total fee for a transaction.
  /// This value is multiplied by the estimated size of the transaction in
  /// bytes to determine the total transaction fee.
  ///
  /// If the result is less than the minimum fee, the minimum fee is used
  /// instead.
  static Future<BigInt> calculateTransactionFee(
      int transactionSize, BigInt suggestedFeePerByte) async {
    var transactionFee = suggestedFeePerByte * BigInt.from(transactionSize);

    // Check min fee
    if (transactionFee < RawTransaction.MIN_TX_FEE_UALGOS) {
      transactionFee = RawTransaction.MIN_TX_FEE_UALGOS;
    }

    return transactionFee;
  }

  /// Returns the estimated encoded size of the transaction, including
  /// the signature.
  ///
  /// This function is useful for calculating the fee from suggested
  /// fee per byte.
  ///
  /// Returns an estimated byte size for the transaction.
  static Future<int> estimateTransactionSize(RawTransaction transaction) async {
    try {
      // Create a random account to sign the transaction
      final account = await Account.random();

      // Sign the transaction
      final signature = await account.sign(transaction.getEncodedTransaction());
      final signedTransaction = SignedTransaction(
        transaction: transaction,
        signature: signature.bytes,
      );

      return Encoder.encodeMessagePack(signedTransaction.toMessagePack())
          .length;
    } catch (ex) {
      return 0;
    }
  }
}
