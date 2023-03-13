// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoxReference _$BoxReferenceFromJson(Map<String, dynamic> json) => BoxReference(
      appIndex: json['i'] as int? ?? 0,
      name: const B64ToByteArrayConverter().fromJson(json['n']),
    );

Map<String, dynamic> _$BoxReferenceToJson(BoxReference instance) =>
    <String, dynamic>{
      'i': instance.appIndex,
      'n': const B64ToByteArrayConverter().toJson(instance.name),
    };
