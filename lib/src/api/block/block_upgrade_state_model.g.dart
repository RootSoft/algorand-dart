// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_upgrade_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockUpgradeState _$BlockUpgradeStateFromJson(Map<String, dynamic> json) =>
    BlockUpgradeState(
      currentProtocol: json['current-protocol'] as String,
      nextProtocol: json['next-protocol'] as String?,
      nextProtocolApprovals: json['next-protocol-approvals'] as int?,
      nextProtocolSwitchOn: json['next-protocol-switch-on'] as int?,
      nextProtocolVoteBefore: json['next-protocol-vote-before'] as int?,
    );

Map<String, dynamic> _$BlockUpgradeStateToJson(BlockUpgradeState instance) =>
    <String, dynamic>{
      'current-protocol': instance.currentProtocol,
      'next-protocol': instance.nextProtocol,
      'next-protocol-approvals': instance.nextProtocolApprovals,
      'next-protocol-switch-on': instance.nextProtocolSwitchOn,
      'next-protocol-vote-before': instance.nextProtocolVoteBefore,
    };
