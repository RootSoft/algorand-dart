import 'package:collection/collection.dart';

import 'exceptions.dart';

class AlgorandFactory {
  static final errors = <String, AlgorandError>{
    'not opted in': NotOptedInError(),
    'overspend': OverspendError(),
    'result negative': ResultNegativeError(),
    'underflow on subtracting': UnderflowOnSubtractError(),
    'below min': BelowMinBalanceError(),
    'but was actually authorized': AuthError(),
  };

  static final AlgorandFactory _singleton = AlgorandFactory._internal();

  AlgorandFactory._internal();

  factory AlgorandFactory() {
    return _singleton;
  }

  void registerError(String key, AlgorandError error) {
    errors.putIfAbsent(key, () => error);
  }

  AlgorandError? tryParse(String text) {
    final errorType = errors.keys.firstWhereOrNull((key) => text.contains(key));
    if (errorType == null) {
      return null;
    }

    return errors[errorType];
  }
}
