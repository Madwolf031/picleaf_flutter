// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
// Imports para sa Machine Learning Side
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class cameraPage extends StatefulWidget {
  const cameraPage({super.key});
  @override
  State<cameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<cameraPage> {
  bool loading = true;
  // Lahat ng comment na ito ay para sa Machine Learning Side

  late File _image;
  List? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 15,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      if (_output != null && _output!.length > 0) {
        loading = false;
      } else {
        _output?[0] = 'Object cannot be identified';
      }
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar para sa taas na design
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "PicLeaf",
          style: TextStyle(
              color: Color.fromRGBO(102, 204, 102, 1.0),
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        shadowColor: const Color.fromARGB(255, 95, 94, 94),
      ),
      backgroundColor: const Color(0xffeeeeee),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          const SizedBox(
            height: 112,
          ),
          Center(
            child: loading
                ? SizedBox(
                    height: 330,
                    width: 250,
                    child: Column(children: <Widget>[
                      Image.asset('assets/images/logo.png')
                    ]),
                  )
                : /*const Text(
                      'Yung mga susunod sana dito yung ilalabas na output kapag na detect yung image') */
                SizedBox(
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 300,
                        child: Image.file(_image),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _output != null
                          ? Text(
                              'Leaf Detected:\n${_output?.elementAt(0)['label'] ?? 'Object cannot be identified.'}',
                              style: const TextStyle(
                                  decorationColor: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'RobotoMedium',
                                  color: Colors.black,
                                  height: 1.5),
                              textAlign: TextAlign.center,
                            )
                          : Container(),
                    ]),
                  ),
          ),
          const SizedBox(
            height: 45,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: const Text(
              'User Tip:\n Make sure that the picture is clear\n to maximize results.',
              style: TextStyle(fontFamily: 'RobotoMedium', fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 77,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0)),
                color: Color.fromARGB(255, 75, 175, 78)),
            child: Column(children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      //Para sa pag open ng Camera pangkuha ng Image
                      pickImage();
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 75,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 75, 175, 78),
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Color(0xffeeeeee),
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        const Text(
                          'Take a Photo',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'RobotoMedium',
                              color: Color(0xffeeeeee)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      //Para sa pag open ng Gallery pangkuha ng Image
                      pickGalleryImage();
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 75,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 75, 175, 78),
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xffeeeeee),
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        const Text(
                          'Add from Gallery',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'RobotoMedium',
                              color: Color(0xffeeeeee)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      )),
    );
  }
}
