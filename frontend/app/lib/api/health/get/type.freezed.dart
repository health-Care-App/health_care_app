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

GetHealthResponse _$GetHealthResponseFromJson(Map<String, dynamic> json) {
  return _GetHealthResponse.fromJson(json);
}

/// @nodoc
mixin _$GetHealthResponse {
  List<Healths>? get healths => throw _privateConstructorUsedError;

  /// Serializes this GetHealthResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetHealthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetHealthResponseCopyWith<GetHealthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetHealthResponseCopyWith<$Res> {
  factory $GetHealthResponseCopyWith(
          GetHealthResponse value, $Res Function(GetHealthResponse) then) =
      _$GetHealthResponseCopyWithImpl<$Res, GetHealthResponse>;
  @useResult
  $Res call({List<Healths>? healths});
}

/// @nodoc
class _$GetHealthResponseCopyWithImpl<$Res, $Val extends GetHealthResponse>
    implements $GetHealthResponseCopyWith<$Res> {
  _$GetHealthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetHealthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? healths = freezed,
  }) {
    return _then(_value.copyWith(
      healths: freezed == healths
          ? _value.healths
          : healths // ignore: cast_nullable_to_non_nullable
              as List<Healths>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetHealthResponseImplCopyWith<$Res>
    implements $GetHealthResponseCopyWith<$Res> {
  factory _$$GetHealthResponseImplCopyWith(_$GetHealthResponseImpl value,
          $Res Function(_$GetHealthResponseImpl) then) =
      __$$GetHealthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Healths>? healths});
}

/// @nodoc
class __$$GetHealthResponseImplCopyWithImpl<$Res>
    extends _$GetHealthResponseCopyWithImpl<$Res, _$GetHealthResponseImpl>
    implements _$$GetHealthResponseImplCopyWith<$Res> {
  __$$GetHealthResponseImplCopyWithImpl(_$GetHealthResponseImpl _value,
      $Res Function(_$GetHealthResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetHealthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? healths = freezed,
  }) {
    return _then(_$GetHealthResponseImpl(
      healths: freezed == healths
          ? _value._healths
          : healths // ignore: cast_nullable_to_non_nullable
              as List<Healths>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetHealthResponseImpl
    with DiagnosticableTreeMixin
    implements _GetHealthResponse {
  const _$GetHealthResponseImpl({required final List<Healths>? healths})
      : _healths = healths;

  factory _$GetHealthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetHealthResponseImplFromJson(json);

  final List<Healths>? _healths;
  @override
  List<Healths>? get healths {
    final value = _healths;
    if (value == null) return null;
    if (_healths is EqualUnmodifiableListView) return _healths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GetHealthResponse(healths: $healths)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GetHealthResponse'))
      ..add(DiagnosticsProperty('healths', healths));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetHealthResponseImpl &&
            const DeepCollectionEquality().equals(other._healths, _healths));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_healths));

  /// Create a copy of GetHealthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetHealthResponseImplCopyWith<_$GetHealthResponseImpl> get copyWith =>
      __$$GetHealthResponseImplCopyWithImpl<_$GetHealthResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetHealthResponseImplToJson(
      this,
    );
  }
}

abstract class _GetHealthResponse implements GetHealthResponse {
  const factory _GetHealthResponse({required final List<Healths>? healths}) =
      _$GetHealthResponseImpl;

  factory _GetHealthResponse.fromJson(Map<String, dynamic> json) =
      _$GetHealthResponseImpl.fromJson;

  @override
  List<Healths>? get healths;

  /// Create a copy of GetHealthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetHealthResponseImplCopyWith<_$GetHealthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Healths _$HealthsFromJson(Map<String, dynamic> json) {
  return _Healths.fromJson(json);
}

/// @nodoc
mixin _$Healths {
  String get id => throw _privateConstructorUsedError;
  DateTime get dateTime => throw _privateConstructorUsedError;
  int get health => throw _privateConstructorUsedError;

  /// Serializes this Healths to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Healths
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthsCopyWith<Healths> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthsCopyWith<$Res> {
  factory $HealthsCopyWith(Healths value, $Res Function(Healths) then) =
      _$HealthsCopyWithImpl<$Res, Healths>;
  @useResult
  $Res call({String id, DateTime dateTime, int health});
}

/// @nodoc
class _$HealthsCopyWithImpl<$Res, $Val extends Healths>
    implements $HealthsCopyWith<$Res> {
  _$HealthsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Healths
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dateTime = null,
    Object? health = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthsImplCopyWith<$Res> implements $HealthsCopyWith<$Res> {
  factory _$$HealthsImplCopyWith(
          _$HealthsImpl value, $Res Function(_$HealthsImpl) then) =
      __$$HealthsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime dateTime, int health});
}

/// @nodoc
class __$$HealthsImplCopyWithImpl<$Res>
    extends _$HealthsCopyWithImpl<$Res, _$HealthsImpl>
    implements _$$HealthsImplCopyWith<$Res> {
  __$$HealthsImplCopyWithImpl(
      _$HealthsImpl _value, $Res Function(_$HealthsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Healths
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dateTime = null,
    Object? health = null,
  }) {
    return _then(_$HealthsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$HealthsImpl with DiagnosticableTreeMixin implements _Healths {
  const _$HealthsImpl(
      {required this.id, required this.dateTime, required this.health});

  factory _$HealthsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthsImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime dateTime;
  @override
  final int health;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Healths(id: $id, dateTime: $dateTime, health: $health)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Healths'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('dateTime', dateTime))
      ..add(DiagnosticsProperty('health', health));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.health, health) || other.health == health));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, dateTime, health);

  /// Create a copy of Healths
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthsImplCopyWith<_$HealthsImpl> get copyWith =>
      __$$HealthsImplCopyWithImpl<_$HealthsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthsImplToJson(
      this,
    );
  }
}

abstract class _Healths implements Healths {
  const factory _Healths(
      {required final String id,
      required final DateTime dateTime,
      required final int health}) = _$HealthsImpl;

  factory _Healths.fromJson(Map<String, dynamic> json) = _$HealthsImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get dateTime;
  @override
  int get health;

  /// Create a copy of Healths
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthsImplCopyWith<_$HealthsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
