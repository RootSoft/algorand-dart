import 'package:algorand_dart/src/abi/return_value.dart';

class ExecuteResult {
  final BigInt confirmedRound;
  final List<String> transactionIds;
  final List<ReturnValue> methodResults;

  ExecuteResult({
    required this.confirmedRound,
    required this.transactionIds,
    required this.methodResults,
  });
}
