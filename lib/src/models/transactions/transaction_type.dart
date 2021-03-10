enum TransactionType {
  RAW,
  PAYMENT,
  KEY_REGISTRATION,
  ASSET_CONFIG,
  ASSET_TRANSFER,
  ASSET_FREEZE,
  APPLICATION_CALL,
}

extension TransactionTypeExtension on TransactionType {
  String get value {
    switch (this) {
      case TransactionType.PAYMENT:
        return 'pay';
      case TransactionType.KEY_REGISTRATION:
        return 'keyreg';
      case TransactionType.ASSET_CONFIG:
        return 'acfg';
      case TransactionType.ASSET_TRANSFER:
        return 'axfer';
      case TransactionType.ASSET_FREEZE:
        return 'afrz';
      case TransactionType.APPLICATION_CALL:
        return 'appl';
      default:
        return '';
    }
  }
}
