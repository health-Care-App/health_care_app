import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'type.freezed.dart';
part 'type.g.dart';

@freezed
class GetHealthResponse with _$GetHealthResponse {
  const factory GetHealthResponse({required List<Healths>? healths}) =
      _GetHealthResponse;
  factory GetHealthResponse.fromJson(Map<String, Object?> json) =>
      _$GetHealthResponseFromJson(json);
}

@freezed
class Healths with _$Healths {
  @JsonSerializable(explicitToJson: true)
  const factory Healths({
    required String id,
    required DateTime dateTime,
    required int health,
  }) = _Healths;

  factory Healths.fromJson(Map<String, Object?> json) =>
      _$HealthsFromJson(json);
}
