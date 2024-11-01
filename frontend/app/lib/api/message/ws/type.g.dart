// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WsMessageRequestImpl _$$WsMessageRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$WsMessageRequestImpl(
      question: json['question'] as String,
      chatModel: (json['chatModel'] as num).toInt(),
      synthModel: (json['synthModel'] as num).toInt(),
      isSynth: json['isSynth'] as bool,
    );

Map<String, dynamic> _$$WsMessageRequestImplToJson(
        _$WsMessageRequestImpl instance) =>
    <String, dynamic>{
      'question': instance.question,
      'chatModel': instance.chatModel,
      'synthModel': instance.synthModel,
      'isSynth': instance.isSynth,
    };

_$WsMessageResponseImpl _$$WsMessageResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WsMessageResponseImpl(
      base64Data: json['base64Data'] as String,
      text: json['text'] as String,
      speakerId: (json['speakerId'] as num).toInt(),
    );

Map<String, dynamic> _$$WsMessageResponseImplToJson(
        _$WsMessageResponseImpl instance) =>
    <String, dynamic>{
      'base64Data': instance.base64Data,
      'text': instance.text,
      'speakerId': instance.speakerId,
    };
