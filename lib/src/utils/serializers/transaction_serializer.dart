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
        // map apar in data
        data.addAll(data['apar'] as Map<String, dynamic>);

        return AssetConfigTransaction.fromJson(data);
      case 'axfer':
        return AssetTransferTransaction.fromJson(data);
      case 'afrz':
        return AssetFreezeTransaction.fromJson(data);
      case 'keyreg':
        return KeyRegistrationTransaction.fromJson(data);
      case 'appl':
        return RawTransaction.fromJson(data);
    }

    return RawTransaction.fromJson(data);
  }

  @override
  Map<String, dynamic> toJson(RawTransaction transaction) =>
      transaction.toMessagePack();
}
