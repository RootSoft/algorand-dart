import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

class ReturnValue {
  final String transactionId;
  final Uint8List? rawValue;
  final Object? value;
  final AbiMethod? method;
  final Object? parseError;
  final PendingTransaction? txInfo;

  ReturnValue({
    required this.transactionId,
    required this.rawValue,
    required this.value,
    required this.method,
    required this.parseError,
    required this.txInfo,
  });
}
