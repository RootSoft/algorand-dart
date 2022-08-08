import 'package:algorand_dart/algorand_dart.dart';

abstract class TxnSigner {
  Future<List<SignedTransaction>> signTransactions(
    List<RawTransaction> transactions,
    List<int> indicesToSign,
  );
}
