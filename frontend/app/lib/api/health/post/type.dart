import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'type.freezed.dart';
part 'type.g.dart';

@freezed
class PostHealthRequest with _$PostHealthRequest {
  const factory PostHealthRequest({required int health}) = _PostHealthRequest;

  factory PostHealthRequest.fromJson(Map<String, Object?> json) =>
      _$PostHealthRequestFromJson(json);
}

@freezed
class PostHealthResponse with _$PostHealthResponse {
  const factory PostHealthResponse({required String message}) = _PostHealthResponse;

  factory PostHealthResponse.fromJson(Map<String, Object?> json) =>
      _$PostHealthResponseFromJson(json);
}
