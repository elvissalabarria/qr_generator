import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_generator/screens/bloc/qr_event.dart';
import 'package:qr_generator/screens/bloc/qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  late TextEditingController bodyQr, urlImagen;
  final List<Color> listColor = [
    Colors.black,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.brown
  ];

  QrBloc() : super(QrState()) {
    bodyQr = TextEditingController();
    urlImagen = TextEditingController();
    on<OnChangeBody>(
      (event, emit) {
        emit(state.copyWith(body: bodyQr.text));
      },
    );
    
  }
}
