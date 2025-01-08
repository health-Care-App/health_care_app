import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'type.freezed.dart';
part 'type.g.dart';

@freezed
class GetMessageResponse with _$GetMessageResponse {
  const factory GetMessageResponse({required List<Messages>? messages}) =
      _GetMessageResponse;
  factory GetMessageResponse.fromJson(Map<String, Object?> json) =>
      _$GetMessageResponseFromJson(json);
}

@freezed
class Messages with _$Messages {
  @JsonSerializable(explicitToJson: true)
  const factory Messages({
    required String id,
    required String question,
    required String answer,
    required DateTime dateTime,
  }) = _Messages;

  factory Messages.fromJson(Map<String, Object?> json) =>
      _$MessagesFromJson(json);
}
