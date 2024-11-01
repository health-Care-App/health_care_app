// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostHealthRequestImpl _$$PostHealthRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PostHealthRequestImpl(
      health: (json['health'] as num).toInt(),
    );

Map<String, dynamic> _$$PostHealthRequestImplToJson(
        _$PostHealthRequestImpl instance) =>
    <String, dynamic>{
      'health': instance.health,
    };

_$PostHealthResponseImpl _$$PostHealthResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PostHealthResponseImpl(
      message: json['message'] as String,
    );

Map<String, dynamic> _$$PostHealthResponseImplToJson(
        _$PostHealthResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
