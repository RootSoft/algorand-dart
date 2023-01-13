// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_participation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountParticipation _$AccountParticipationFromJson(
        Map<String, dynamic> json) =>
    AccountParticipation(
      selectionParticipationKey: json['selection-participation-key'] as String?,
      stateProofKey: json['state-proof-key'] as String?,
      voteFirstValid: json['vote-first-valid'] as int? ?? 0,
      voteKeyDilution: json['vote-key-dilution'] as int? ?? 0,
      voteLastValid: json['vote-last-valid'] as int? ?? 0,
      voteParticipationKey: json['vote-participation-key'] as String?,
    );

Map<String, dynamic> _$AccountParticipationToJson(
        AccountParticipation instance) =>
    <String, dynamic>{
      'selection-participation-key': instance.selectionParticipationKey,
      'state-proof-key': instance.stateProofKey,
      'vote-first-valid': instance.voteFirstValid,
      'vote-key-dilution': instance.voteKeyDilution,
      'vote-last-valid': instance.voteLastValid,
      'vote-participation-key': instance.voteParticipationKey,
    };
