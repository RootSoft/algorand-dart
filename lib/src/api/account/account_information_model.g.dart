// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_information_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountInformation _$AccountInformationFromJson(Map<String, dynamic> json) =>
    AccountInformation(
      address: json['address'] as String,
      amount: const BigIntSerializer().fromJson(json['amount']),
      amountWithoutPendingRewards: const BigIntSerializer()
          .fromJson(json['amount-without-pending-rewards']),
      pendingRewards:
          const BigIntSerializer().fromJson(json['pending-rewards']),
      rewards: const BigIntSerializer().fromJson(json['rewards']),
      round: const BigIntSerializer().fromJson(json['round']),
      status: json['status'] as String,
      deleted: json['deleted'] as bool? ?? false,
      assets: (json['assets'] as List<dynamic>?)
              ?.map((e) => AssetHolding.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      appsLocalState: (json['apps-local-state'] as List<dynamic>?)
              ?.map((e) =>
                  ApplicationLocalState.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdApps: (json['created-apps'] as List<dynamic>?)
              ?.map((e) => Application.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAssets: (json['created-assets'] as List<dynamic>?)
              ?.map((e) => Asset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalAppsOptedIn: json['total-apps-opted-in'] as int? ?? 0,
      totalAssetsOptedIn: json['total-assets-opted-in'] as int? ?? 0,
      totalBoxBytes: json['total-box-bytes'] as int?,
      totalBoxes: json['total-boxes'] as int?,
      totalCreatedApps: json['total-created-apps'] as int? ?? 0,
      totalCreatedAssets: json['total-created-assets'] as int? ?? 0,
      createdAtRound: json['created-at-round'] as int?,
      participation: json['participation'] == null
          ? null
          : AccountParticipation.fromJson(
              json['participation'] as Map<String, dynamic>),
      rewardBase:
          const NullableBigIntSerializer().fromJson(json['reward-base']),
      closedAtRound: json['closed-at-round'] as int?,
      signatureType:
          $enumDecodeNullable(_$SignatureTypeEnumMap, json['sig-type']),
      authAddress: json['auth-addr'] as String?,
      appsTotalSchema: json['apps-total-schema'] == null
          ? null
          : ApplicationStateSchema.fromJson(
              json['apps-total-schema'] as Map<String, dynamic>),
      minimumBalance:
          const NullableBigIntSerializer().fromJson(json['min-balance']),
      appsTotalExtraPages: json['apps-total-extra-pages'] as int?,
    );

Map<String, dynamic> _$AccountInformationToJson(AccountInformation instance) =>
    <String, dynamic>{
      'address': instance.address,
      'amount': const BigIntSerializer().toJson(instance.amount),
      'amount-without-pending-rewards':
          const BigIntSerializer().toJson(instance.amountWithoutPendingRewards),
      'created-at-round': instance.createdAtRound,
      'deleted': instance.deleted,
      'pending-rewards':
          const BigIntSerializer().toJson(instance.pendingRewards),
      'reward-base':
          const NullableBigIntSerializer().toJson(instance.rewardBase),
      'rewards': const BigIntSerializer().toJson(instance.rewards),
      'round': const BigIntSerializer().toJson(instance.round),
      'status': instance.status,
      'closed-at-round': instance.closedAtRound,
      'sig-type': _$SignatureTypeEnumMap[instance.signatureType],
      'auth-addr': instance.authAddress,
      'assets': instance.assets,
      'apps-local-state': instance.appsLocalState,
      'apps-total-extra-pages': instance.appsTotalExtraPages,
      'apps-total-schema': instance.appsTotalSchema,
      'created-apps': instance.createdApps,
      'created-assets': instance.createdAssets,
      'participation': instance.participation,
      'min-balance':
          const NullableBigIntSerializer().toJson(instance.minimumBalance),
      'total-apps-opted-in': instance.totalAppsOptedIn,
      'total-assets-opted-in': instance.totalAssetsOptedIn,
      'total-box-bytes': instance.totalBoxBytes,
      'total-boxes': instance.totalBoxes,
      'total-created-apps': instance.totalCreatedApps,
      'total-created-assets': instance.totalCreatedAssets,
    };

const _$SignatureTypeEnumMap = {
  SignatureType.STANDARD: 'sig',
  SignatureType.MULTI: 'msig',
  SignatureType.LOGIC: 'lsig',
};
