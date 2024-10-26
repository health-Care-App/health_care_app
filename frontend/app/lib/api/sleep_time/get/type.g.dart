// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetSleepTimeResponseImpl _$$GetSleepTimeResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetSleepTimeResponseImpl(
      sleepTimes: (json['sleepTimes'] as List<dynamic>?)
          ?.map((e) => SleepTimes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GetSleepTimeResponseImplToJson(
        _$GetSleepTimeResponseImpl instance) =>
    <String, dynamic>{
      'sleepTimes': instance.sleepTimes,
    };

_$SleepTimesImpl _$$SleepTimesImplFromJson(Map<String, dynamic> json) =>
    _$SleepTimesImpl(
      id: json['id'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      sleepTime: (json['sleepTime'] as num).toInt(),
    );

Map<String, dynamic> _$$SleepTimesImplToJson(_$SleepTimesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateTime': instance.dateTime.toIso8601String(),
      'sleepTime': instance.sleepTime,
    };
