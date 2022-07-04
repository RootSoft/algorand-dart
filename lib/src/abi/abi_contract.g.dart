// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abi_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbiContract _$AbiContractFromJson(Map<String, dynamic> json) => AbiContract(
      name: json['name'] as String? ?? '',
      description: json['desc'] as String? ?? '',
      networks: (json['networks'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, NetworkInfo.fromJson(e as Map<String, dynamic>)),
      ),
      methods: (json['methods'] as List<dynamic>)
          .map((e) => AbiMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AbiContractToJson(AbiContract instance) =>
    <String, dynamic>{
      'name': instance.name,
      'desc': instance.description,
      'networks': instance.networks.map((k, e) => MapEntry(k, e.toJson())),
      'methods': instance.methods.map((e) => e.toJson()).toList(),
    };
