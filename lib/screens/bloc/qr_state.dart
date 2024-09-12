import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_state.freezed.dart';

@freezed
class QrState with _$QrState {
  factory QrState(
    {
    @Default('') String body,
     @Default(false) bool imageSaved,
     @Default(Colors.black) Color color,
     }) =
      _QrState;
}
