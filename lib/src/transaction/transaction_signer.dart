import 'package:algorand_dart/algorand_dart.dart';

abstract class TxnSigner {
  List<SignedTransaction> signTransactions(
    List<RawTransaction> transactions,
    List<int> indicesToSign,
  );
}
