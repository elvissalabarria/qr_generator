// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:universal_html/html.dart' as html;

import 'package:http/http.dart' as http;
import 'package:qr_generator/utils/utils.dart';

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
  bool kIsWeb = identical(0, 0.0);

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
  // late TextRecognizer textDetector;

  bool textScanning = false;

  XFile? imageFile;

  String scannedText = '';
  CameraController? controllerCamera;

  // TextRecognizer? textDetector;
  @override
  void initState() {
    super.initState();
    imagePath = '';
    controller = TextEditingController();
    controllerUrlImage = TextEditingController();
  }

  // void _initializeVision() async {
  //   textDetector = FirebaseVision.instance.textRecognizer();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qr Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              // getImage();
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
                  (!kIsWeb)
                      ? ElevatedButton(
                          onPressed: () {
                            saveQrImage();
                          },
                          child: const Text('Save image'))
                      : const SizedBox(),
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
      color: (colorNotifier.value == 0) ? Colors.white : listColor[colorNotifier.value],
      gapless: true,
      embeddedImageStyle: null,
      embeddedImage: null,
    );
    if (!kIsWeb) {
      final picData = await painter.toImageData(2048, format: ui.ImageByteFormat.png);
      await writeToFile(picData!, path);
    } else {}
  }

  Future<void> downloadImage(String imageUrl) async {
    try {
      // first we make a request to the url like you did
      // in the android and ios version
      final http.Response r = await http.get(
        Uri.parse(imageUrl),
      );

      // we get the bytes from the body
      final data = r.bodyBytes;
      // and encode them to base64
      final base64data = base64Encode(data);

      // then we create and AnchorElement with the html package
      final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');

      // set the name of the file we want the image to get
      // downloaded to
      a.download = 'download.jpg';

      // and we click the AnchorElement which downloads the image
      a.click();
      // finally we remove the AnchorElement
      a.remove();
    } catch (e) {
      print(e);
    }
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

  // void recognizTexts() async {
  //   final inputImage = InputImage.fromFilePath(imagePath);
  //   final text = await textDetector.processImage(inputImage);
  //   for (TextBlock block in text.blocks) {
  //     for (TextLine line in block.lines) {
  //       print('text: ${line.text}');
  //     }
  //   }
  // }

  // Future imageToText(inputImage) async {
  //   final textDetector = GoogleMlKit.vision.textRecognizer();
  //   final RecognizedText recognizedText = await textDetector.processImage(inputImage);
  //   setState(() {
  //     String text = recognizedText.text;
  //     for (TextBlock block in recognizedText.blocks) {
  //       for (TextLine line in block.lines) {
  //         for (TextElement element in line.elements) {}
  //       }
  //     }
  //   });
  // }

  void getImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;

        getRecognisedText(pickedImage);
        setState(() {});
      }
    } catch (e) {
      textScanning = true;
      imageFile = null;
      scannedText = "Error occurred while scanning";
    }
  }

  // Future<String> _takePicture() async {
  //   // Checking whether the controller is initialized
  //   if (!controllerCamera!.value.isInitialized) {
  //     print("Controller is not initialized");
  //     return  "Controller is not initialized";
  //   }

  //   // Formatting Date and Time
  //   String dateTime =
  //       DateFormat.yMMMd().addPattern('-').add_Hms().format(DateTime.now()).toString();

  //   String formattedDateTime = dateTime.replaceAll(' ', '');
  //   print("Formatted: $formattedDateTime");

  //   // Retrieving the path for saving an image
  //   final Directory appDocDir = await getApplicationDocumentsDirectory();
  //   final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
  //   await Directory(visionDir).create(recursive: true);
  //   final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

  //   // Checking whether the picture is being taken
  //   // to prevent execution of the function again
  //   // if previous execution has not ended
  //   if (controllerCamera!.value.isTakingPicture) {
  //     print("Processing is in progress...");
  //     return "Processing is in progress...";
  //   }

  //   try {
  //     // Captures the image and saves it to the
  //     // provided path
  //     await controllerCamera!.takePicture(imagePath);
  //     // ignore: nullable_type_in_catch_clause
  //   } on CameraException catch (e) {
  //     print("Camera Exception: $e");
  //     return controllerCamera;
  //   }

  //   return imagePath;
  // }

  void getRecognisedText(XFile image) async {
    // final File imageFile = File(image.path);
    // final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

    // final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    // final VisionText visionText = await textRecognizer.processImage(visionImage);
    // for (TextBlock block in visionText.blocks) {
    //   for (TextLine line in block.lines) {
    //     // Checking if the line contains an email address
    //     scannedText += ('${line.text}\n');
    //   }
    // }
    // final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

    // FirebaseVision.instance.imageLabeler().processImage(visionImage).then((labels) {
    //   print(labels.map((e) => e.text).toList());
    // });
    // FirebaseVision.instance.textRecognizer().processImage(visionImage).then((value) => {
    //       // value.blocks.forEach((block) => {
    //       //       block.lines.forEach((line) => {
    //       //             line.elements
    //       //                 .forEach((element) => {scannedText = "$scannedText${element.text!} "})
    //       //           })
    //       //     })
    //       print(value.text),
    //     });

    // final inputImage = InputImage.fromFilePath(image.path);
    // final File imageFile = File(image.path);

    // final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    // final textDectetor = GoogleMlKit.vision.textDetector();
// final FirebaseVisionImage visionImage =
//      FirebaseVisionImage.fromFile(image.path);

// final TextRecognizer textRecognizer =
//      FirebaseVision.instance.textRecognizer();
//   textDetector = FirebaseVision.instance.textRecognizer();
    // await textDectetor.close();
    // scannedText = '';

    controller.text = scannedText;
    textScanning = false;
    print(scannedText);
    setState(() {});
  }

  void createQrImage() {
    if (formKey.currentState!.validate()) {
      final qrDataInfo = controller.text.trim();
      qrNotifier.value = qrDataInfo;
    }
  }
}
