import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'type.freezed.dart';
part 'type.g.dart';

@freezed
class PostSleepTimeRequest with _$PostSleepTimeRequest {
  const factory PostSleepTimeRequest({required int sleepTime}) =
      _PostSleepTimeRequest;

  factory PostSleepTimeRequest.fromJson(Map<String, Object?> json) =>
      _$PostSleepTimeRequestFromJson(json);
}

@freezed
class PostSleepTimeResponse with _$PostSleepTimeResponse {
  const factory PostSleepTimeResponse({required String message}) =
      _PostSleepTimeResponse;

  factory PostSleepTimeResponse.fromJson(Map<String, Object?> json) =>
      _$PostSleepTimeResponseFromJson(json);
}
