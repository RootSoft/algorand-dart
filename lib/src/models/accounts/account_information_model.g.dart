// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_information_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountInformation _$AccountInformationFromJson(Map<String, dynamic> json) =>
    AccountInformation(
      address: json['address'] as String,
      amount: json['amount'] as int,
      amountWithoutPendingRewards:
          json['amount-without-pending-rewards'] as int,
      pendingRewards: json['pending-rewards'] as int,
      rewards: json['rewards'] as int,
      round: json['round'] as int,
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
      createdAtRound: json['created-at-round'] as int?,
      participation: json['participation'] == null
          ? null
          : AccountParticipation.fromJson(
              json['participation'] as Map<String, dynamic>),
      rewardBase: json['reward-base'] as int?,
      closedAtRound: json['closed-at-round'] as int?,
      signatureType:
          $enumDecodeNullable(_$SignatureTypeEnumMap, json['sig-type']),
      authAddress: json['auth-addr'] as String?,
      appsTotalSchema: json['apps-total-schema'] == null
          ? null
          : ApplicationStateSchema.fromJson(
              json['apps-total-schema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountInformationToJson(AccountInformation instance) =>
    <String, dynamic>{
      'address': instance.address,
      'amount': instance.amount,
      'amount-without-pending-rewards': instance.amountWithoutPendingRewards,
      'created-at-round': instance.createdAtRound,
      'deleted': instance.deleted,
      'pending-rewards': instance.pendingRewards,
      'reward-base': instance.rewardBase,
      'rewards': instance.rewards,
      'round': instance.round,
      'status': instance.status,
      'closed-at-round': instance.closedAtRound,
      'sig-type': _$SignatureTypeEnumMap[instance.signatureType],
      'auth-addr': instance.authAddress,
      'assets': instance.assets,
      'apps-local-state': instance.appsLocalState,
      'apps-total-schema': instance.appsTotalSchema,
      'created-apps': instance.createdApps,
      'created-assets': instance.createdAssets,
      'participation': instance.participation,
    };

const _$SignatureTypeEnumMap = {
  SignatureType.STANDARD: 'sig',
  SignatureType.MULTI: 'msig',
  SignatureType.LOGIC: 'lsig',
};
