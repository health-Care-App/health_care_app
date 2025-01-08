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

PostHealthRequest _$PostHealthRequestFromJson(Map<String, dynamic> json) {
  return _PostHealthRequest.fromJson(json);
}

/// @nodoc
mixin _$PostHealthRequest {
  int get health => throw _privateConstructorUsedError;

  /// Serializes this PostHealthRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostHealthRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostHealthRequestCopyWith<PostHealthRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostHealthRequestCopyWith<$Res> {
  factory $PostHealthRequestCopyWith(
          PostHealthRequest value, $Res Function(PostHealthRequest) then) =
      _$PostHealthRequestCopyWithImpl<$Res, PostHealthRequest>;
  @useResult
  $Res call({int health});
}

/// @nodoc
class _$PostHealthRequestCopyWithImpl<$Res, $Val extends PostHealthRequest>
    implements $PostHealthRequestCopyWith<$Res> {
  _$PostHealthRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostHealthRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? health = null,
  }) {
    return _then(_value.copyWith(
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostHealthRequestImplCopyWith<$Res>
    implements $PostHealthRequestCopyWith<$Res> {
  factory _$$PostHealthRequestImplCopyWith(_$PostHealthRequestImpl value,
          $Res Function(_$PostHealthRequestImpl) then) =
      __$$PostHealthRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int health});
}

/// @nodoc
class __$$PostHealthRequestImplCopyWithImpl<$Res>
    extends _$PostHealthRequestCopyWithImpl<$Res, _$PostHealthRequestImpl>
    implements _$$PostHealthRequestImplCopyWith<$Res> {
  __$$PostHealthRequestImplCopyWithImpl(_$PostHealthRequestImpl _value,
      $Res Function(_$PostHealthRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostHealthRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? health = null,
  }) {
    return _then(_$PostHealthRequestImpl(
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostHealthRequestImpl
    with DiagnosticableTreeMixin
    implements _PostHealthRequest {
  const _$PostHealthRequestImpl({required this.health});

  factory _$PostHealthRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostHealthRequestImplFromJson(json);

  @override
  final int health;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PostHealthRequest(health: $health)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PostHealthRequest'))
      ..add(DiagnosticsProperty('health', health));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostHealthRequestImpl &&
            (identical(other.health, health) || other.health == health));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, health);

  /// Create a copy of PostHealthRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostHealthRequestImplCopyWith<_$PostHealthRequestImpl> get copyWith =>
      __$$PostHealthRequestImplCopyWithImpl<_$PostHealthRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostHealthRequestImplToJson(
      this,
    );
  }
}

abstract class _PostHealthRequest implements PostHealthRequest {
  const factory _PostHealthRequest({required final int health}) =
      _$PostHealthRequestImpl;

  factory _PostHealthRequest.fromJson(Map<String, dynamic> json) =
      _$PostHealthRequestImpl.fromJson;

  @override
  int get health;

  /// Create a copy of PostHealthRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostHealthRequestImplCopyWith<_$PostHealthRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostHealthResponse _$PostHealthResponseFromJson(Map<String, dynamic> json) {
  return _PostHealthResponse.fromJson(json);
}

/// @nodoc
mixin _$PostHealthResponse {
  String get message => throw _privateConstructorUsedError;

  /// Serializes this PostHealthResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostHealthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostHealthResponseCopyWith<PostHealthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostHealthResponseCopyWith<$Res> {
  factory $PostHealthResponseCopyWith(
          PostHealthResponse value, $Res Function(PostHealthResponse) then) =
      _$PostHealthResponseCopyWithImpl<$Res, PostHealthResponse>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$PostHealthResponseCopyWithImpl<$Res, $Val extends PostHealthResponse>
    implements $PostHealthResponseCopyWith<$Res> {
  _$PostHealthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostHealthResponse
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
abstract class _$$PostHealthResponseImplCopyWith<$Res>
    implements $PostHealthResponseCopyWith<$Res> {
  factory _$$PostHealthResponseImplCopyWith(_$PostHealthResponseImpl value,
          $Res Function(_$PostHealthResponseImpl) then) =
      __$$PostHealthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PostHealthResponseImplCopyWithImpl<$Res>
    extends _$PostHealthResponseCopyWithImpl<$Res, _$PostHealthResponseImpl>
    implements _$$PostHealthResponseImplCopyWith<$Res> {
  __$$PostHealthResponseImplCopyWithImpl(_$PostHealthResponseImpl _value,
      $Res Function(_$PostHealthResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostHealthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$PostHealthResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostHealthResponseImpl
    with DiagnosticableTreeMixin
    implements _PostHealthResponse {
  const _$PostHealthResponseImpl({required this.message});

  factory _$PostHealthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostHealthResponseImplFromJson(json);

  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PostHealthResponse(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PostHealthResponse'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostHealthResponseImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PostHealthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostHealthResponseImplCopyWith<_$PostHealthResponseImpl> get copyWith =>
      __$$PostHealthResponseImplCopyWithImpl<_$PostHealthResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostHealthResponseImplToJson(
      this,
    );
  }
}

abstract class _PostHealthResponse implements PostHealthResponse {
  const factory _PostHealthResponse({required final String message}) =
      _$PostHealthResponseImpl;

  factory _PostHealthResponse.fromJson(Map<String, dynamic> json) =
      _$PostHealthResponseImpl.fromJson;

  @override
  String get message;

  /// Create a copy of PostHealthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostHealthResponseImplCopyWith<_$PostHealthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
