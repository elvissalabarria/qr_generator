import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_state.freezed.dart';

@freezed
class QrState with _$QrState {
  factory QrState({
    @Default('') String body,
    @Default('') String urlImagen,
    @Default(false) bool imageSaved,
    @Default(false) bool showImage,
    @Default(Colors.black) Color color,
    @Default(false) bool errorCreateImage,
  }) = _QrState;
}
