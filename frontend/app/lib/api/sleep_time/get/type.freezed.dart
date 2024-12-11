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

GetSleepTimeResponse _$GetSleepTimeResponseFromJson(Map<String, dynamic> json) {
  return _GetSleepTimeResponse.fromJson(json);
}

/// @nodoc
mixin _$GetSleepTimeResponse {
  List<SleepTimes>? get sleepTimes => throw _privateConstructorUsedError;

  /// Serializes this GetSleepTimeResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetSleepTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetSleepTimeResponseCopyWith<GetSleepTimeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetSleepTimeResponseCopyWith<$Res> {
  factory $GetSleepTimeResponseCopyWith(GetSleepTimeResponse value,
          $Res Function(GetSleepTimeResponse) then) =
      _$GetSleepTimeResponseCopyWithImpl<$Res, GetSleepTimeResponse>;
  @useResult
  $Res call({List<SleepTimes>? sleepTimes});
}

/// @nodoc
class _$GetSleepTimeResponseCopyWithImpl<$Res,
        $Val extends GetSleepTimeResponse>
    implements $GetSleepTimeResponseCopyWith<$Res> {
  _$GetSleepTimeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetSleepTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sleepTimes = freezed,
  }) {
    return _then(_value.copyWith(
      sleepTimes: freezed == sleepTimes
          ? _value.sleepTimes
          : sleepTimes // ignore: cast_nullable_to_non_nullable
              as List<SleepTimes>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetSleepTimeResponseImplCopyWith<$Res>
    implements $GetSleepTimeResponseCopyWith<$Res> {
  factory _$$GetSleepTimeResponseImplCopyWith(_$GetSleepTimeResponseImpl value,
          $Res Function(_$GetSleepTimeResponseImpl) then) =
      __$$GetSleepTimeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SleepTimes>? sleepTimes});
}

/// @nodoc
class __$$GetSleepTimeResponseImplCopyWithImpl<$Res>
    extends _$GetSleepTimeResponseCopyWithImpl<$Res, _$GetSleepTimeResponseImpl>
    implements _$$GetSleepTimeResponseImplCopyWith<$Res> {
  __$$GetSleepTimeResponseImplCopyWithImpl(_$GetSleepTimeResponseImpl _value,
      $Res Function(_$GetSleepTimeResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetSleepTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sleepTimes = freezed,
  }) {
    return _then(_$GetSleepTimeResponseImpl(
      sleepTimes: freezed == sleepTimes
          ? _value._sleepTimes
          : sleepTimes // ignore: cast_nullable_to_non_nullable
              as List<SleepTimes>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetSleepTimeResponseImpl
    with DiagnosticableTreeMixin
    implements _GetSleepTimeResponse {
  const _$GetSleepTimeResponseImpl(
      {required final List<SleepTimes>? sleepTimes})
      : _sleepTimes = sleepTimes;

  factory _$GetSleepTimeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetSleepTimeResponseImplFromJson(json);

  final List<SleepTimes>? _sleepTimes;
  @override
  List<SleepTimes>? get sleepTimes {
    final value = _sleepTimes;
    if (value == null) return null;
    if (_sleepTimes is EqualUnmodifiableListView) return _sleepTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GetSleepTimeResponse(sleepTimes: $sleepTimes)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GetSleepTimeResponse'))
      ..add(DiagnosticsProperty('sleepTimes', sleepTimes));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetSleepTimeResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._sleepTimes, _sleepTimes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_sleepTimes));

  /// Create a copy of GetSleepTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetSleepTimeResponseImplCopyWith<_$GetSleepTimeResponseImpl>
      get copyWith =>
          __$$GetSleepTimeResponseImplCopyWithImpl<_$GetSleepTimeResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetSleepTimeResponseImplToJson(
      this,
    );
  }
}

abstract class _GetSleepTimeResponse implements GetSleepTimeResponse {
  const factory _GetSleepTimeResponse(
          {required final List<SleepTimes>? sleepTimes}) =
      _$GetSleepTimeResponseImpl;

  factory _GetSleepTimeResponse.fromJson(Map<String, dynamic> json) =
      _$GetSleepTimeResponseImpl.fromJson;

  @override
  List<SleepTimes>? get sleepTimes;

  /// Create a copy of GetSleepTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetSleepTimeResponseImplCopyWith<_$GetSleepTimeResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SleepTimes _$SleepTimesFromJson(Map<String, dynamic> json) {
  return _SleepTimes.fromJson(json);
}

/// @nodoc
mixin _$SleepTimes {
  String get id => throw _privateConstructorUsedError;
  DateTime get dateTime => throw _privateConstructorUsedError;
  int get sleepTime => throw _privateConstructorUsedError;

  /// Serializes this SleepTimes to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SleepTimes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SleepTimesCopyWith<SleepTimes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SleepTimesCopyWith<$Res> {
  factory $SleepTimesCopyWith(
          SleepTimes value, $Res Function(SleepTimes) then) =
      _$SleepTimesCopyWithImpl<$Res, SleepTimes>;
  @useResult
  $Res call({String id, DateTime dateTime, int sleepTime});
}

/// @nodoc
class _$SleepTimesCopyWithImpl<$Res, $Val extends SleepTimes>
    implements $SleepTimesCopyWith<$Res> {
  _$SleepTimesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SleepTimes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dateTime = null,
    Object? sleepTime = null,
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
      sleepTime: null == sleepTime
          ? _value.sleepTime
          : sleepTime // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SleepTimesImplCopyWith<$Res>
    implements $SleepTimesCopyWith<$Res> {
  factory _$$SleepTimesImplCopyWith(
          _$SleepTimesImpl value, $Res Function(_$SleepTimesImpl) then) =
      __$$SleepTimesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime dateTime, int sleepTime});
}

/// @nodoc
class __$$SleepTimesImplCopyWithImpl<$Res>
    extends _$SleepTimesCopyWithImpl<$Res, _$SleepTimesImpl>
    implements _$$SleepTimesImplCopyWith<$Res> {
  __$$SleepTimesImplCopyWithImpl(
      _$SleepTimesImpl _value, $Res Function(_$SleepTimesImpl) _then)
      : super(_value, _then);

  /// Create a copy of SleepTimes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dateTime = null,
    Object? sleepTime = null,
  }) {
    return _then(_$SleepTimesImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sleepTime: null == sleepTime
          ? _value.sleepTime
          : sleepTime // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SleepTimesImpl with DiagnosticableTreeMixin implements _SleepTimes {
  const _$SleepTimesImpl(
      {required this.id, required this.dateTime, required this.sleepTime});

  factory _$SleepTimesImpl.fromJson(Map<String, dynamic> json) =>
      _$$SleepTimesImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime dateTime;
  @override
  final int sleepTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SleepTimes(id: $id, dateTime: $dateTime, sleepTime: $sleepTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SleepTimes'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('dateTime', dateTime))
      ..add(DiagnosticsProperty('sleepTime', sleepTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepTimesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.sleepTime, sleepTime) ||
                other.sleepTime == sleepTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, dateTime, sleepTime);

  /// Create a copy of SleepTimes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SleepTimesImplCopyWith<_$SleepTimesImpl> get copyWith =>
      __$$SleepTimesImplCopyWithImpl<_$SleepTimesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SleepTimesImplToJson(
      this,
    );
  }
}

abstract class _SleepTimes implements SleepTimes {
  const factory _SleepTimes(
      {required final String id,
      required final DateTime dateTime,
      required final int sleepTime}) = _$SleepTimesImpl;

  factory _SleepTimes.fromJson(Map<String, dynamic> json) =
      _$SleepTimesImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get dateTime;
  @override
  int get sleepTime;

  /// Create a copy of SleepTimes
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SleepTimesImplCopyWith<_$SleepTimesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
