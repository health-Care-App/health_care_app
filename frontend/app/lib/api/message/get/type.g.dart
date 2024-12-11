// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetMessageResponseImpl _$$GetMessageResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetMessageResponseImpl(
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Messages.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GetMessageResponseImplToJson(
        _$GetMessageResponseImpl instance) =>
    <String, dynamic>{
      'messages': instance.messages,
    };

_$MessagesImpl _$$MessagesImplFromJson(Map<String, dynamic> json) =>
    _$MessagesImpl(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$$MessagesImplToJson(_$MessagesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'dateTime': instance.dateTime.toIso8601String(),
    };
