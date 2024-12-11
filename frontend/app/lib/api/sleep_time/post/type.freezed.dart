// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostSleepTimeRequest _$PostSleepTimeRequestFromJson(Map<String, dynamic> json) {
  return _PostSleepTimeRequest.fromJson(json);
}

/// @nodoc
mixin _$PostSleepTimeRequest {
  int get sleepTime => throw _privateConstructorUsedError;

  /// Serializes this PostSleepTimeRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostSleepTimeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostSleepTimeRequestCopyWith<PostSleepTimeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostSleepTimeRequestCopyWith<$Res> {
  factory $PostSleepTimeRequestCopyWith(PostSleepTimeRequest value,
          $Res Function(PostSleepTimeRequest) then) =
      _$PostSleepTimeRequestCopyWithImpl<$Res, PostSleepTimeRequest>;
  @useResult
  $Res call({int sleepTime});
}

/// @nodoc
class _$PostSleepTimeRequestCopyWithImpl<$Res,
        $Val extends PostSleepTimeRequest>
    implements $PostSleepTimeRequestCopyWith<$Res> {
  _$PostSleepTimeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostSleepTimeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sleepTime = null,
  }) {
    return _then(_value.copyWith(
      sleepTime: null == sleepTime
          ? _value.sleepTime
          : sleepTime // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostSleepTimeRequestImplCopyWith<$Res>
    implements $PostSleepTimeRequestCopyWith<$Res> {
  factory _$$PostSleepTimeRequestImplCopyWith(_$PostSleepTimeRequestImpl value,
          $Res Function(_$PostSleepTimeRequestImpl) then) =
      __$$PostSleepTimeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int sleepTime});
}

/// @nodoc
class __$$PostSleepTimeRequestImplCopyWithImpl<$Res>
    extends _$PostSleepTimeRequestCopyWithImpl<$Res, _$PostSleepTimeRequestImpl>
    implements _$$PostSleepTimeRequestImplCopyWith<$Res> {
  __$$PostSleepTimeRequestImplCopyWithImpl(_$PostSleepTimeRequestImpl _value,
      $Res Function(_$PostSleepTimeRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostSleepTimeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sleepTime = null,
  }) {
    return _then(_$PostSleepTimeRequestImpl(
      sleepTime: null == sleepTime
          ? _value.sleepTime
          : sleepTime // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostSleepTimeRequestImpl
    with DiagnosticableTreeMixin
    implements _PostSleepTimeRequest {
  const _$PostSleepTimeRequestImpl({required this.sleepTime});

  factory _$PostSleepTimeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostSleepTimeRequestImplFromJson(json);

  @override
  final int sleepTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PostSleepTimeRequest(sleepTime: $sleepTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PostSleepTimeRequest'))
      ..add(DiagnosticsProperty('sleepTime', sleepTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostSleepTimeRequestImpl &&
            (identical(other.sleepTime, sleepTime) ||
                other.sleepTime == sleepTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sleepTime);

  /// Create a copy of PostSleepTimeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostSleepTimeRequestImplCopyWith<_$PostSleepTimeRequestImpl>
      get copyWith =>
          __$$PostSleepTimeRequestImplCopyWithImpl<_$PostSleepTimeRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostSleepTimeRequestImplToJson(
      this,
    );
  }
}

abstract class _PostSleepTimeRequest implements PostSleepTimeRequest {
  const factory _PostSleepTimeRequest({required final int sleepTime}) =
      _$PostSleepTimeRequestImpl;

  factory _PostSleepTimeRequest.fromJson(Map<String, dynamic> json) =
      _$PostSleepTimeRequestImpl.fromJson;

  @override
  int get sleepTime;

  /// Create a copy of PostSleepTimeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostSleepTimeRequestImplCopyWith<_$PostSleepTimeRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PostSleepTimeResponse _$PostSleepTimeResponseFromJson(
    Map<String, dynamic> json) {
  return _PostSleepTimeResponse.fromJson(json);
}

/// @nodoc
mixin _$PostSleepTimeResponse {
  String get message => throw _privateConstructorUsedError;

  /// Serializes this PostSleepTimeResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostSleepTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostSleepTimeResponseCopyWith<PostSleepTimeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostSleepTimeResponseCopyWith<$Res> {
  factory $PostSleepTimeResponseCopyWith(PostSleepTimeResponse value,
          $Res Function(PostSleepTimeResponse) then) =
      _$PostSleepTimeResponseCopyWithImpl<$Res, PostSleepTimeResponse>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$PostSleepTimeResponseCopyWithImpl<$Res,
        $Val extends PostSleepTimeResponse>
    implements $PostSleepTimeResponseCopyWith<$Res> {
  _$PostSleepTimeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostSleepTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostSleepTimeResponseImplCopyWith<$Res>
    implements $PostSleepTimeResponseCopyWith<$Res> {
  factory _$$PostSleepTimeResponseImplCopyWith(
          _$PostSleepTimeResponseImpl value,
          $Res Function(_$PostSleepTimeResponseImpl) then) =
      __$$PostSleepTimeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PostSleepTimeResponseImplCopyWithImpl<$Res>
    extends _$PostSleepTimeResponseCopyWithImpl<$Res,
        _$PostSleepTimeResponseImpl>
    implements _$$PostSleepTimeResponseImplCopyWith<$Res> {
  __$$PostSleepTimeResponseImplCopyWithImpl(_$PostSleepTimeResponseImpl _value,
      $Res Function(_$PostSleepTimeResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostSleepTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$PostSleepTimeResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostSleepTimeResponseImpl
    with DiagnosticableTreeMixin
    implements _PostSleepTimeResponse {
  const _$PostSleepTimeResponseImpl({required this.message});

  factory _$PostSleepTimeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostSleepTimeResponseImplFromJson(json);

  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PostSleepTimeResponse(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PostSleepTimeResponse'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostSleepTimeResponseImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PostSleepTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostSleepTimeResponseImplCopyWith<_$PostSleepTimeResponseImpl>
      get copyWith => __$$PostSleepTimeResponseImplCopyWithImpl<
          _$PostSleepTimeResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostSleepTimeResponseImplToJson(
      this,
    );
  }
}

abstract class _PostSleepTimeResponse implements PostSleepTimeResponse {
  const factory _PostSleepTimeResponse({required final String message}) =
      _$PostSleepTimeResponseImpl;

  factory _PostSleepTimeResponse.fromJson(Map<String, dynamic> json) =
      _$PostSleepTimeResponseImpl.fromJson;

  @override
  String get message;

  /// Create a copy of PostSleepTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostSleepTimeResponseImplCopyWith<_$PostSleepTimeResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
