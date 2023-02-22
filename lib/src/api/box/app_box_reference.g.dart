// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_box_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppBoxReference _$AppBoxReferenceFromJson(Map<String, dynamic> json) =>
    AppBoxReference(
      applicationId: json['i'] as int? ?? 0,
      name: const B64ToByteArrayConverter().fromJson(json['n']),
    );

Map<String, dynamic> _$AppBoxReferenceToJson(AppBoxReference instance) =>
    <String, dynamic>{
      'i': instance.applicationId,
      'n': const B64ToByteArrayConverter().toJson(instance.name),
    };
