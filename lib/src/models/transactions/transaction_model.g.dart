// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return Transaction(
    id: json['id'] as String?,
    fee: json['fee'] as int,
    firstValid: json['first-valid'] as int,
    lastValid: json['last-valid'] as int,
    sender: json['sender'] as String,
    type: json['tx-type'] as String,
    signature: json['signature'] == null
        ? null
        : TransactionSignature.fromJson(
            json['signature'] as Map<String, dynamic>),
    globalStateDelta: (json['global-state-delta'] as List<dynamic>?)
            ?.map((e) => EvalDeltaKeyValue.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    localStateDelta: (json['local-state-delta'] as List<dynamic>?)
            ?.map((e) => AccountStateDelta.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    innerTxns: (json['inner-txns'] as List<dynamic>?)
            ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    logs: (json['logs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    createdApplicationIndex: json['created-application-index'] as int?,
    createdAssetIndex: json['created-asset-index'] as int?,
    closeRewards: json['close-rewards'] as int?,
    closingAmount: json['closing-amount'] as int?,
    confirmedRound: json['confirmed-round'] as int?,
    genesisHash: json['genesis-hash'] as String?,
    genesisId: json['genesis-id'] as String?,
    intraRoundOffset: json['intra-round-offset'] as int?,
    receiverRewards: json['receiver-rewards'] as int?,
    roundTime: json['round-time'] as int?,
    senderRewards: json['sender-rewards'] as int?,
    group: json['group'] as String?,
    lease: json['lease'] as String?,
    note: json['note'] as String?,
    authAddress: json['auth-addr'] as String?,
    rekeyTo: json['rekey-to'] as String?,
    paymentTransaction: json['payment-transaction'] == null
        ? null
        : PaymentTransactionResponse.fromJson(
            json['payment-transaction'] as Map<String, dynamic>),
    applicationTransaction: json['application-transaction'] == null
        ? null
        : ApplicationTransactionResponse.fromJson(
            json['application-transaction'] as Map<String, dynamic>),
    assetConfigTransaction: json['asset-config-transaction'] == null
        ? null
        : AssetConfigTransactionResponse.fromJson(
            json['asset-config-transaction'] as Map<String, dynamic>),
    assetFreezeTransaction: json['asset-freeze-transaction'] == null
        ? null
        : AssetFreezeTransactionResponse.fromJson(
            json['asset-freeze-transaction'] as Map<String, dynamic>),
    assetTransferTransaction: json['asset-transfer-transaction'] == null
        ? null
        : AssetTransferTransactionResponse.fromJson(
            json['asset-transfer-transaction'] as Map<String, dynamic>),
    keyRegistrationTransaction: json['keyreg-transaction'] == null
        ? null
        : KeyRegistrationTransactionResponse.fromJson(
            json['keyreg-transaction'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'close-rewards': instance.closeRewards,
      'closing-amount': instance.closingAmount,
      'confirmed-round': instance.confirmedRound,
      'created-application-index': instance.createdApplicationIndex,
      'created-asset-index': instance.createdAssetIndex,
      'fee': instance.fee,
      'first-valid': instance.firstValid,
      'genesis-hash': instance.genesisHash,
      'genesis-id': instance.genesisId,
      'global-state-delta': instance.globalStateDelta,
      'local-state-delta': instance.localStateDelta,
      'logs': instance.logs,
      'group': instance.group,
      'lease': instance.lease,
      'id': instance.id,
      'intra-round-offset': instance.intraRoundOffset,
      'last-valid': instance.lastValid,
      'receiver-rewards': instance.receiverRewards,
      'round-time': instance.roundTime,
      'sender': instance.sender,
      'sender-rewards': instance.senderRewards,
      'signature': instance.signature,
      'tx-type': instance.type,
      'note': instance.note,
      'auth-addr': instance.authAddress,
      'rekey-to': instance.rekeyTo,
      'inner-txns': instance.innerTxns,
      'payment-transaction': instance.paymentTransaction,
      'application-transaction': instance.applicationTransaction,
      'asset-config-transaction': instance.assetConfigTransaction,
      'asset-freeze-transaction': instance.assetFreezeTransaction,
      'asset-transfer-transaction': instance.assetTransferTransaction,
      'keyreg-transaction': instance.keyRegistrationTransaction,
    };
