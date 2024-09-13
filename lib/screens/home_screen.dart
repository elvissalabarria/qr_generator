// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/screens/bloc/qr_bloc.dart';
import 'package:qr_generator/screens/bloc/qr_event.dart';
import 'package:qr_generator/screens/bloc/qr_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:qr_generator/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final imageUrlNotifier = ValueNotifier<String>(
      'https://avatars.githubusercontent.com/u/46904863?v=4');
  final formKey = GlobalKey<FormState>();
  final showImageNotifier = ValueNotifier<bool>(false);
  bool kIsWeb = identical(0, 0.0);
  StreamSubscription? _sub;
  late SharedPreferences prefs;
  final String lastValue = 'lastValue';
  final String urlImage = 'urlImage';
  late String result;
  late final String imagePath;
  bool textScanning = false;

  @override
  void initState() {
    super.initState();
    imagePath = '';
    // controller = TextEditingController();
    // controllerUrlImage = TextEditingController();
    // SharedPreferences.getInstance().then((value) {
    //   prefs = value;
    //   if (prefs.containsKey(lastValue)) {
    //     controller.text = prefs.getString(lastValue)!;
    //   }
    //   if (prefs.containsKey(urlImage)) {
    //     controllerUrlImage.text = prefs.getString(urlImage)!;
    //   }
    // });

    getWebsiteData();
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
      body: BlocListener<QrBloc, QrState>(
        listener: (context, state) {
          if (state.errorCreateImage) {
            Utils().showError(context, 'error al crear qr');
          }
        },
        child: BlocBuilder<QrBloc, QrState>(
          builder: (context, state) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            controller: context.read<QrBloc>().bodyQr,
                            onChanged: (value) {
                              context.read<QrBloc>().add(const OnChangeBody());
                            },
                            onFieldSubmitted: (value) {
                              context.read<QrBloc>().add(const OnChangeBody());
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: (state.body.isNotEmpty)
                                  ? state.body
                                  : 'Enter text to generate QR code',
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            controller: context.read<QrBloc>().urlImagen,
                            onChanged: (value) {
                              context
                                  .read<QrBloc>()
                                  .add(const OnChangeImageUrl());
                            },
                            onFieldSubmitted: (value) {
                              context
                                  .read<QrBloc>()
                                  .add(const OnChangeImageUrl());
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: (state.urlImagen.isNotEmpty)
                                  ? state.urlImagen
                                  : 'Define URL image to generate QR code',
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
                            context.read<QrBloc>().add(const OnChangeBody());
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
                                  context
                                      .read<QrBloc>()
                                      .add(OnChangeColor(index));
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Utils().listColor[index],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                  ),
                                ),
                              ),
                            );
                          }),
                          itemCount: Utils().listColor.length,
                          shrinkWrap: true),
                    ),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text(
                        'Show image in Qr?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Switch(
                          value: state.showImage,
                          onChanged: (value) {
                            context.read<QrBloc>().add(const OnShowImagen());
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ]),
                    QrImageView(
                      data: state.body,
                      foregroundColor: state.color,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () {
                          context.read<QrBloc>().add(const OnSaveImagen());
                        },
                        child: const Text('Save image'))
                  ],
                )));
          },
        ),
      ),
    );
  }

  Future getWebsiteData() async {
    final url = Uri.parse(
        'https://www.codegrepper.com/code-examples/whatever/event+js+get+selected+text');
    final response = await http.get(url);
    dom.Document document = dom.Document.html(response.body);
    final tittle = document.getElementById("box1");
    var selection = html.window.getSelection().toString();
    print(selection);
  }

  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      // Parse the link and warn the user, if it is not correct,

      // but keep in mind it could be `null`.
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }
}
