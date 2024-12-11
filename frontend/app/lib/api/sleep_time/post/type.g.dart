// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostSleepTimeRequestImpl _$$PostSleepTimeRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PostSleepTimeRequestImpl(
      sleepTime: (json['sleepTime'] as num).toInt(),
    );

Map<String, dynamic> _$$PostSleepTimeRequestImplToJson(
        _$PostSleepTimeRequestImpl instance) =>
    <String, dynamic>{
      'sleepTime': instance.sleepTime,
    };

_$PostSleepTimeResponseImpl _$$PostSleepTimeResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PostSleepTimeResponseImpl(
      message: json['message'] as String,
    );

Map<String, dynamic> _$$PostSleepTimeResponseImplToJson(
        _$PostSleepTimeResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
