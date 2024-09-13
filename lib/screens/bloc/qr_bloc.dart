import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/screens/bloc/qr_event.dart';
import 'package:qr_generator/screens/bloc/qr_state.dart';
import 'package:qr_generator/utils/utils.dart';
import 'package:universal_html/html.dart' as html;

class QrBloc extends Bloc<QrEvent, QrState> {
  late TextEditingController bodyQr, urlImagen;

  QrBloc() : super(QrState()) {
    bodyQr = TextEditingController();
    urlImagen = TextEditingController();
    on<OnChangeBody>(
      (event, emit) {
        emit(state.copyWith(body: bodyQr.text));
      },
    );
    on<OnChangeImageUrl>(
      (event, emit) {
        emit(state.copyWith(urlImagen: urlImagen.text));
      },
    );
    on<OnChangeColor>(
      (event, emit) {
        emit(state.copyWith(color: Utils().listColor[event.pos]));
      },
    );
    on<OnShowImagen>(
      (event, emit) {
        emit(state.copyWith(showImage: !state.showImage));
      },
    );
    on<OnSaveImagen>(
      (event, emit) async {
        final image = await QrPainter(
                data: state.body,
                version: QrVersions.auto,
                errorCorrectionLevel: QrErrorCorrectLevel.Q,
                color: state.color,
                embeddedImage: null)
            .toImageData(400);

        if (!kIsWeb) {
          io.Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path;
          final ts = DateTime.now().millisecondsSinceEpoch.toString();
          String path = '$tempPath/$ts.png';
          await writeToFile(image!, path);
        } else {
          var pngBytes = image!.buffer.asUint8List();
          try {
            final a = html.AnchorElement(
                href: 'data:image/jpeg;base64,${base64Encode(pngBytes)}');
            a.download = 'download.jpg';
            a.click();
            a.remove();
          } catch (e) {
            // Utils().showError(context, "Error downloading image");
            emit(state.copyWith(errorCreateImage: true, imageSaved: false));
          }
        }
      },
    );
  }

  writeToFile(ByteData byteData, String path) {
    final buffer = byteData.buffer;
    io.File(path)
        .writeAsBytes(
            buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes))
        .then((value) => {
              GallerySaver.saveImage(value.path).then((value) {
                (value!)
                    // ignore: invalid_use_of_visible_for_testing_member
                    ? emit(state.copyWith(
                        errorCreateImage: false, imageSaved: true))
                    // ignore: invalid_use_of_visible_for_testing_member
                    : emit(state.copyWith(
                        errorCreateImage: true, imageSaved: false));
              })
            });
  }
}
