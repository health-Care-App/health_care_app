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

WsMessageRequest _$WsMessageRequestFromJson(Map<String, dynamic> json) {
  return _WsMessageRequest.fromJson(json);
}

/// @nodoc
mixin _$WsMessageRequest {
  String get question => throw _privateConstructorUsedError;
  int get chatModel => throw _privateConstructorUsedError;
  int get synthModel => throw _privateConstructorUsedError;
  bool get isSynth => throw _privateConstructorUsedError;

  /// Serializes this WsMessageRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WsMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WsMessageRequestCopyWith<WsMessageRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WsMessageRequestCopyWith<$Res> {
  factory $WsMessageRequestCopyWith(
          WsMessageRequest value, $Res Function(WsMessageRequest) then) =
      _$WsMessageRequestCopyWithImpl<$Res, WsMessageRequest>;
  @useResult
  $Res call({String question, int chatModel, int synthModel, bool isSynth});
}

/// @nodoc
class _$WsMessageRequestCopyWithImpl<$Res, $Val extends WsMessageRequest>
    implements $WsMessageRequestCopyWith<$Res> {
  _$WsMessageRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WsMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? chatModel = null,
    Object? synthModel = null,
    Object? isSynth = null,
  }) {
    return _then(_value.copyWith(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      chatModel: null == chatModel
          ? _value.chatModel
          : chatModel // ignore: cast_nullable_to_non_nullable
              as int,
      synthModel: null == synthModel
          ? _value.synthModel
          : synthModel // ignore: cast_nullable_to_non_nullable
              as int,
      isSynth: null == isSynth
          ? _value.isSynth
          : isSynth // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WsMessageRequestImplCopyWith<$Res>
    implements $WsMessageRequestCopyWith<$Res> {
  factory _$$WsMessageRequestImplCopyWith(_$WsMessageRequestImpl value,
          $Res Function(_$WsMessageRequestImpl) then) =
      __$$WsMessageRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String question, int chatModel, int synthModel, bool isSynth});
}

/// @nodoc
class __$$WsMessageRequestImplCopyWithImpl<$Res>
    extends _$WsMessageRequestCopyWithImpl<$Res, _$WsMessageRequestImpl>
    implements _$$WsMessageRequestImplCopyWith<$Res> {
  __$$WsMessageRequestImplCopyWithImpl(_$WsMessageRequestImpl _value,
      $Res Function(_$WsMessageRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of WsMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? chatModel = null,
    Object? synthModel = null,
    Object? isSynth = null,
  }) {
    return _then(_$WsMessageRequestImpl(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      chatModel: null == chatModel
          ? _value.chatModel
          : chatModel // ignore: cast_nullable_to_non_nullable
              as int,
      synthModel: null == synthModel
          ? _value.synthModel
          : synthModel // ignore: cast_nullable_to_non_nullable
              as int,
      isSynth: null == isSynth
          ? _value.isSynth
          : isSynth // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WsMessageRequestImpl
    with DiagnosticableTreeMixin
    implements _WsMessageRequest {
  const _$WsMessageRequestImpl(
      {required this.question,
      required this.chatModel,
      required this.synthModel,
      required this.isSynth});

  factory _$WsMessageRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$WsMessageRequestImplFromJson(json);

  @override
  final String question;
  @override
  final int chatModel;
  @override
  final int synthModel;
  @override
  final bool isSynth;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WsMessageRequest(question: $question, chatModel: $chatModel, synthModel: $synthModel, isSynth: $isSynth)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WsMessageRequest'))
      ..add(DiagnosticsProperty('question', question))
      ..add(DiagnosticsProperty('chatModel', chatModel))
      ..add(DiagnosticsProperty('synthModel', synthModel))
      ..add(DiagnosticsProperty('isSynth', isSynth));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WsMessageRequestImpl &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.chatModel, chatModel) ||
                other.chatModel == chatModel) &&
            (identical(other.synthModel, synthModel) ||
                other.synthModel == synthModel) &&
            (identical(other.isSynth, isSynth) || other.isSynth == isSynth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, question, chatModel, synthModel, isSynth);

  /// Create a copy of WsMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WsMessageRequestImplCopyWith<_$WsMessageRequestImpl> get copyWith =>
      __$$WsMessageRequestImplCopyWithImpl<_$WsMessageRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WsMessageRequestImplToJson(
      this,
    );
  }
}

abstract class _WsMessageRequest implements WsMessageRequest {
  const factory _WsMessageRequest(
      {required final String question,
      required final int chatModel,
      required final int synthModel,
      required final bool isSynth}) = _$WsMessageRequestImpl;

  factory _WsMessageRequest.fromJson(Map<String, dynamic> json) =
      _$WsMessageRequestImpl.fromJson;

  @override
  String get question;
  @override
  int get chatModel;
  @override
  int get synthModel;
  @override
  bool get isSynth;

  /// Create a copy of WsMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WsMessageRequestImplCopyWith<_$WsMessageRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WsMessageResponse _$WsMessageResponseFromJson(Map<String, dynamic> json) {
  return _WsMessageResponse.fromJson(json);
}

/// @nodoc
mixin _$WsMessageResponse {
  String get base64Data => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  int get speakerId => throw _privateConstructorUsedError;

  /// Serializes this WsMessageResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WsMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WsMessageResponseCopyWith<WsMessageResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WsMessageResponseCopyWith<$Res> {
  factory $WsMessageResponseCopyWith(
          WsMessageResponse value, $Res Function(WsMessageResponse) then) =
      _$WsMessageResponseCopyWithImpl<$Res, WsMessageResponse>;
  @useResult
  $Res call({String base64Data, String text, int speakerId});
}

/// @nodoc
class _$WsMessageResponseCopyWithImpl<$Res, $Val extends WsMessageResponse>
    implements $WsMessageResponseCopyWith<$Res> {
  _$WsMessageResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WsMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? base64Data = null,
    Object? text = null,
    Object? speakerId = null,
  }) {
    return _then(_value.copyWith(
      base64Data: null == base64Data
          ? _value.base64Data
          : base64Data // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      speakerId: null == speakerId
          ? _value.speakerId
          : speakerId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WsMessageResponseImplCopyWith<$Res>
    implements $WsMessageResponseCopyWith<$Res> {
  factory _$$WsMessageResponseImplCopyWith(_$WsMessageResponseImpl value,
          $Res Function(_$WsMessageResponseImpl) then) =
      __$$WsMessageResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String base64Data, String text, int speakerId});
}

/// @nodoc
class __$$WsMessageResponseImplCopyWithImpl<$Res>
    extends _$WsMessageResponseCopyWithImpl<$Res, _$WsMessageResponseImpl>
    implements _$$WsMessageResponseImplCopyWith<$Res> {
  __$$WsMessageResponseImplCopyWithImpl(_$WsMessageResponseImpl _value,
      $Res Function(_$WsMessageResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of WsMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? base64Data = null,
    Object? text = null,
    Object? speakerId = null,
  }) {
    return _then(_$WsMessageResponseImpl(
      base64Data: null == base64Data
          ? _value.base64Data
          : base64Data // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      speakerId: null == speakerId
          ? _value.speakerId
          : speakerId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WsMessageResponseImpl
    with DiagnosticableTreeMixin
    implements _WsMessageResponse {
  const _$WsMessageResponseImpl(
      {required this.base64Data, required this.text, required this.speakerId});

  factory _$WsMessageResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WsMessageResponseImplFromJson(json);

  @override
  final String base64Data;
  @override
  final String text;
  @override
  final int speakerId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WsMessageResponse(base64Data: $base64Data, text: $text, speakerId: $speakerId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WsMessageResponse'))
      ..add(DiagnosticsProperty('base64Data', base64Data))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('speakerId', speakerId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WsMessageResponseImpl &&
            (identical(other.base64Data, base64Data) ||
                other.base64Data == base64Data) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.speakerId, speakerId) ||
                other.speakerId == speakerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, base64Data, text, speakerId);

  /// Create a copy of WsMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WsMessageResponseImplCopyWith<_$WsMessageResponseImpl> get copyWith =>
      __$$WsMessageResponseImplCopyWithImpl<_$WsMessageResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WsMessageResponseImplToJson(
      this,
    );
  }
}

abstract class _WsMessageResponse implements WsMessageResponse {
  const factory _WsMessageResponse(
      {required final String base64Data,
      required final String text,
      required final int speakerId}) = _$WsMessageResponseImpl;

  factory _WsMessageResponse.fromJson(Map<String, dynamic> json) =
      _$WsMessageResponseImpl.fromJson;

  @override
  String get base64Data;
  @override
  String get text;
  @override
  int get speakerId;

  /// Create a copy of WsMessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WsMessageResponseImplCopyWith<_$WsMessageResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
