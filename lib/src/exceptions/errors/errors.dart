import 'package:algorand_dart/src/exceptions/errors/algorand_error.dart';

class OverspendError extends AlgorandError {}

class NotOptedInError extends AlgorandError {}

class ResultNegativeError extends AlgorandError {}

class UnderflowOnSubtractError extends AlgorandError {}

class BelowMinBalanceError extends AlgorandError {}

class AuthError extends AlgorandError {}
