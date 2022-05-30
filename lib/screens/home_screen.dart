// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

import 'package:qr_generator/utils/utils.dart';

// import 'package:learning_input_image/learning_input_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController controller;
  late TextEditingController controllerUrlImage;
  final qrNotifier = ValueNotifier<String>('');
  final colorNotifier = ValueNotifier<int>(0);
  final imageUrlNotifier =
      ValueNotifier<String>('https://avatars.githubusercontent.com/u/46904863?v=4');
  final formKey = GlobalKey<FormState>();
  final showImageNotifier = ValueNotifier<bool>(false);

  late String result;
  // InputImage? inputImage;
  final picker = ImagePicker();
  late final String imagePath;
  final List<Color> listColor = [
    Colors.black,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.brown
  ];
  late TextRecognizer textDetector;
  @override
  void initState() {
    super.initState();
    imagePath = '';
    controller = TextEditingController();
    controllerUrlImage = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qr Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              // textDetector = GoogleMlKit.vision.textRecognizer();
              // recognizTexts();
              // InputCameraView(
              //   canSwitchMode: false,
              //   mode: InputCameraMode.gallery,
              //   title: 'Text Recognition',
              //   onImage: (image) {
              //     imageToText(image);
              //   },
              // );
              // captureImageFromCamera();
              // FutureBuilder<String?>(
              //     future: SampleCallNativeFlutter.checkImage(),
              //     builder: (_, snapshoot) {
              //       print(snapshoot.data ?? 'no dat');
              //       return Text(snapshoot.data ?? '');
              //     });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: colorNotifier,
            builder: (context, value, child) {
              return Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: controller,
                          onChanged: (value) {
                            createQrImage();
                          },
                          onFieldSubmitted: (value) {
                            createQrImage();
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Enter text to generate QR code',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: controllerUrlImage,
                          onChanged: (value) {
                            imageUrlNotifier.value = controllerUrlImage.text;
                          },
                          onFieldSubmitted: (value) {
                            imageUrlNotifier.value = controllerUrlImage.text;
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            labelText: 'Define URL image to generate QR code',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                        onPressed: () {
                          createQrImage();
                        },
                        child: const Text('Generate QR code')),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select color Qr code',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 70,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                colorNotifier.value = index;
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: listColor[index],
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                            ),
                          );
                        }),
                        itemCount: listColor.length,
                        shrinkWrap: true),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Show image in Qr?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ValueListenableBuilder(
                        valueListenable: showImageNotifier,
                        builder: (context, value, child) {
                          return Switch(
                            value: showImageNotifier.value,
                            onChanged: (value) {
                              showImageNotifier.value = value;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder(
                      valueListenable: qrNotifier,
                      builder: (context, value, child) {
                        return ValueListenableBuilder(
                          valueListenable: imageUrlNotifier,
                          builder: (context, value, child) {
                            return ValueListenableBuilder(
                              valueListenable: showImageNotifier,
                              builder: (context, value, child) {
                                return QrImage(
                                  embeddedImage: (showImageNotifier.value)
                                      ? NetworkImage(imageUrlNotifier.value)
                                      : null,
                                  data: qrNotifier.value,
                                  version: QrVersions.auto,
                                  foregroundColor: listColor[colorNotifier.value],
                                  size: 200.0,
                                );
                              },
                            );
                          },
                        );
                      }),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () {
                        saveQrImage();
                      },
                      child: const Text('Save image')),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void takeScreenShot() async {
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {
      final boundary = formKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();

        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
          '$directory/${DateTime.now()}qr.png',
        );
        imgFile.writeAsBytes(pngBytes);
      }
    }
  }

  Future<void> saveQrImage() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';
    final qrValidationResult = QrValidator.validate(
      data: qrNotifier.value,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    final qrCode = qrValidationResult.qrCode;

    final painter = QrPainter.withQr(
      qr: qrCode!,
      color: listColor[colorNotifier.value],
      gapless: true,
      embeddedImageStyle: null,
      embeddedImage: null,
    );
    final picData = await painter.toImageData(2048, format: ui.ImageByteFormat.png);
    await writeToFile(picData!, path);
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    File(path)
        .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes))
        .then((value) => {
              GallerySaver.saveImage(value.path).then((value) {
                (value!)
                    ? Utils().showError(context, "Image saved successfully")
                    : Utils().showError(context, "Image not saved");
              })
            });
  }

  void recognizTexts() async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final text = await textDetector.processImage(inputImage);
    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        print('text: ${line.text}');
      }
    }
  }

  Future imageToText(inputImage) async {
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textDetector.processImage(inputImage);
    setState(() {
      String text = recognizedText.text;
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {}
        }
      }
    });
  }

  void createQrImage() {
    if (formKey.currentState!.validate()) {
      final qrDataInfo = controller.text.trim();
      qrNotifier.value = qrDataInfo;
    }
  }
}
