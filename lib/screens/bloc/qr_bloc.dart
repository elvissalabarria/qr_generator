import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_generator/screens/bloc/qr_event.dart';
import 'package:qr_generator/screens/bloc/qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  
  late TextEditingController bodyQr, urlImagen;

  QrBloc() : super(QrState()) {
    bodyQr = TextEditingController();
    urlImagen = TextEditingController();
   
  }
}
