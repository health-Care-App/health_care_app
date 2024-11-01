import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'type.freezed.dart';
part 'type.g.dart';

@freezed
class GetSleepTimeResponse with _$GetSleepTimeResponse {
  const factory GetSleepTimeResponse({required List<SleepTimes>? sleepTimes}) =
      _GetSleepTimeResponse;
  factory GetSleepTimeResponse.fromJson(Map<String, Object?> json) =>
      _$GetSleepTimeResponseFromJson(json);
}

@freezed
class SleepTimes with _$SleepTimes {
  @JsonSerializable(explicitToJson: true)
  const factory SleepTimes({
    required String id,
    required DateTime dateTime,
    required int sleepTime,
  }) = _SleepTimes;

  factory SleepTimes.fromJson(Map<String, Object?> json) =>
      _$SleepTimesFromJson(json);
}
