// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

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
                        // saveImageQr(qrNotifier.value);
                        takeScreenShot();
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
        // getting directory of our phone
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
          '$directory/${DateTime.now()}qr.png',
        );
        imgFile.writeAsBytes(pngBytes);
      }
    }
  }

  Future<void> saveQrImage() async {
    final directory = await getApplicationDocumentsDirectory();
    File('${directory.path}/qr.png');
  }

  // Future captureImageFromCamera() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //       inputImage = InputImage.fromFilePath(pickedFile.path);
  //       imageToText(inputImage);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  Future<void> captureAndSharePng() async {
    try {
      // ignore: prefer_typing_uninitialized_variables
      var globalKey;
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      const channel = MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }

  void recognizTexts() async {
    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(imagePath);
    // Retrieving the RecognisedText from the InputImage
    final text = await textDetector.processImage(inputImage);
    // Finding text String(s)
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
