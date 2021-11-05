// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic_signature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogicSignature _$LogicSignatureFromJson(Map<String, dynamic> json) =>
    LogicSignature(
      logic: const ByteArraySerializer().fromJson(json['l']),
      arguments: const ListByteArraySerializer().fromJson(json['arg']),
      signature: const SignatureSerializer().fromJson(json['sig']),
    );

Map<String, dynamic> _$LogicSignatureToJson(LogicSignature instance) =>
    <String, dynamic>{
      'l': const ByteArraySerializer().toJson(instance.logic),
      'arg': const ListByteArraySerializer().toJson(instance.arguments),
      'sig': const SignatureSerializer().toJson(instance.signature),
    };
