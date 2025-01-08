import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'type.freezed.dart';
part 'type.g.dart';

@freezed
class WsMessageRequest with _$WsMessageRequest {
  const factory WsMessageRequest({
    required String question,
    required int chatModel,
    required int synthModel,
    required bool isSynth,
    }) = _WsMessageRequest;
  factory WsMessageRequest.fromJson(Map<String, Object?> json) =>
      _$WsMessageRequestFromJson(json);
}

@freezed
class WsMessageResponse with _$WsMessageResponse {
  const factory WsMessageResponse({
    required String base64Data,
    required String text,
    required int speakerId,
    }) = _WsMessageResponse;
  factory WsMessageResponse.fromJson(Map<String, Object?> json) =>
      _$WsMessageResponseFromJson(json);
}