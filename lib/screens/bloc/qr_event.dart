import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_event.freezed.dart';

@freezed
class QrEvent with _$QrEvent {
  const factory QrEvent.started() = Started;
  const factory QrEvent.onSaveImagen() = OnSaveImagen;
  const factory QrEvent.onChangeBody() = OnChangeBody;
  const factory QrEvent.onChangeColor(int pos)= OnChangeColor;
}
