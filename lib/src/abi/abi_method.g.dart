// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abi_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbiMethod _$AbiMethodFromJson(Map<String, dynamic> json) => AbiMethod(
      name: json['name'] as String? ?? '',
      description: json['desc'] as String? ?? '',
      arguments: (json['args'] as List<dynamic>?)
              ?.map((e) => Argument.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      returns: json['returns'] == null
          ? const Returns()
          : Returns.fromJson(json['returns'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AbiMethodToJson(AbiMethod instance) => <String, dynamic>{
      'name': instance.name,
      'desc': instance.description,
      'args': instance.arguments.map((e) => e.toJson()).toList(),
      'returns': instance.returns.toJson(),
    };
