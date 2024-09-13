// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QrState {
  String get body => throw _privateConstructorUsedError;
  String get urlImagen => throw _privateConstructorUsedError;
  bool get imageSaved => throw _privateConstructorUsedError;
  bool get showImage => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;
  bool get errorCreateImage => throw _privateConstructorUsedError;

  /// Create a copy of QrState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QrStateCopyWith<QrState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrStateCopyWith<$Res> {
  factory $QrStateCopyWith(QrState value, $Res Function(QrState) then) =
      _$QrStateCopyWithImpl<$Res, QrState>;
  @useResult
  $Res call(
      {String body,
      String urlImagen,
      bool imageSaved,
      bool showImage,
      Color color,
      bool errorCreateImage});
}

/// @nodoc
class _$QrStateCopyWithImpl<$Res, $Val extends QrState>
    implements $QrStateCopyWith<$Res> {
  _$QrStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QrState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? body = null,
    Object? urlImagen = null,
    Object? imageSaved = null,
    Object? showImage = null,
    Object? color = null,
    Object? errorCreateImage = null,
  }) {
    return _then(_value.copyWith(
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      urlImagen: null == urlImagen
          ? _value.urlImagen
          : urlImagen // ignore: cast_nullable_to_non_nullable
              as String,
      imageSaved: null == imageSaved
          ? _value.imageSaved
          : imageSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      showImage: null == showImage
          ? _value.showImage
          : showImage // ignore: cast_nullable_to_non_nullable
              as bool,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      errorCreateImage: null == errorCreateImage
          ? _value.errorCreateImage
          : errorCreateImage // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QrStateImplCopyWith<$Res> implements $QrStateCopyWith<$Res> {
  factory _$$QrStateImplCopyWith(
          _$QrStateImpl value, $Res Function(_$QrStateImpl) then) =
      __$$QrStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String body,
      String urlImagen,
      bool imageSaved,
      bool showImage,
      Color color,
      bool errorCreateImage});
}

/// @nodoc
class __$$QrStateImplCopyWithImpl<$Res>
    extends _$QrStateCopyWithImpl<$Res, _$QrStateImpl>
    implements _$$QrStateImplCopyWith<$Res> {
  __$$QrStateImplCopyWithImpl(
      _$QrStateImpl _value, $Res Function(_$QrStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of QrState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? body = null,
    Object? urlImagen = null,
    Object? imageSaved = null,
    Object? showImage = null,
    Object? color = null,
    Object? errorCreateImage = null,
  }) {
    return _then(_$QrStateImpl(
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      urlImagen: null == urlImagen
          ? _value.urlImagen
          : urlImagen // ignore: cast_nullable_to_non_nullable
              as String,
      imageSaved: null == imageSaved
          ? _value.imageSaved
          : imageSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      showImage: null == showImage
          ? _value.showImage
          : showImage // ignore: cast_nullable_to_non_nullable
              as bool,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      errorCreateImage: null == errorCreateImage
          ? _value.errorCreateImage
          : errorCreateImage // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$QrStateImpl implements _QrState {
  _$QrStateImpl(
      {this.body = '',
      this.urlImagen = '',
      this.imageSaved = false,
      this.showImage = false,
      this.color = Colors.black,
      this.errorCreateImage = false});

  @override
  @JsonKey()
  final String body;
  @override
  @JsonKey()
  final String urlImagen;
  @override
  @JsonKey()
  final bool imageSaved;
  @override
  @JsonKey()
  final bool showImage;
  @override
  @JsonKey()
  final Color color;
  @override
  @JsonKey()
  final bool errorCreateImage;

  @override
  String toString() {
    return 'QrState(body: $body, urlImagen: $urlImagen, imageSaved: $imageSaved, showImage: $showImage, color: $color, errorCreateImage: $errorCreateImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrStateImpl &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.urlImagen, urlImagen) ||
                other.urlImagen == urlImagen) &&
            (identical(other.imageSaved, imageSaved) ||
                other.imageSaved == imageSaved) &&
            (identical(other.showImage, showImage) ||
                other.showImage == showImage) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.errorCreateImage, errorCreateImage) ||
                other.errorCreateImage == errorCreateImage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, body, urlImagen, imageSaved,
      showImage, color, errorCreateImage);

  /// Create a copy of QrState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QrStateImplCopyWith<_$QrStateImpl> get copyWith =>
      __$$QrStateImplCopyWithImpl<_$QrStateImpl>(this, _$identity);
}

abstract class _QrState implements QrState {
  factory _QrState(
      {final String body,
      final String urlImagen,
      final bool imageSaved,
      final bool showImage,
      final Color color,
      final bool errorCreateImage}) = _$QrStateImpl;

  @override
  String get body;
  @override
  String get urlImagen;
  @override
  bool get imageSaved;
  @override
  bool get showImage;
  @override
  Color get color;
  @override
  bool get errorCreateImage;

  /// Create a copy of QrState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QrStateImplCopyWith<_$QrStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
