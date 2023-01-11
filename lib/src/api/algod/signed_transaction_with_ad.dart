import 'package:algorand_dart/src/api/algod/algod_transaction.dart';
import 'package:algorand_dart/src/api/algod/apply_data.dart';

class SignedTransactionWithAD {
  final AlgodTransaction txn;
  final ApplyData? applyData;

  SignedTransactionWithAD({
    required this.txn,
    this.applyData,
  });
}
