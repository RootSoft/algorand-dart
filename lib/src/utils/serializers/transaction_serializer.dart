import 'package:algorand_dart/src/api/transactions/application_transaction.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

class TransactionSerializer
    implements JsonConverter<RawTransaction, Map<String, dynamic>> {
  const TransactionSerializer();

  @override
  RawTransaction fromJson(Map<String, dynamic> data) {
    final type = data['type'] ?? '';
    switch (type) {
      case 'pay':
        return PaymentTransaction.fromJson(data);
      case 'acfg':
        return AssetConfigTransaction.fromJson(data);
      case 'axfer':
        return AssetTransferTransaction.fromJson(data);
      case 'afrz':
        return AssetFreezeTransaction.fromJson(data);
      case 'keyreg':
        return KeyRegistrationTransaction.fromJson(data);
      case 'appl':
        return ApplicationTransaction.fromJson(data);
    }

    return RawTransaction.fromJson(data);
  }

  @override
  Map<String, dynamic> toJson(RawTransaction transaction) =>
      transaction.toMessagePack();
}
