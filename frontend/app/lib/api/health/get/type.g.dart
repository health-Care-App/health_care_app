// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetHealthResponseImpl _$$GetHealthResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetHealthResponseImpl(
      healths: (json['healths'] as List<dynamic>?)
          ?.map((e) => Healths.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GetHealthResponseImplToJson(
        _$GetHealthResponseImpl instance) =>
    <String, dynamic>{
      'healths': instance.healths,
    };

_$HealthsImpl _$$HealthsImplFromJson(Map<String, dynamic> json) =>
    _$HealthsImpl(
      id: json['id'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      health: (json['health'] as num).toInt(),
    );

Map<String, dynamic> _$$HealthsImplToJson(_$HealthsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateTime': instance.dateTime.toIso8601String(),
      'health': instance.health,
    };
