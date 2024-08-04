import 'package:picleaf/widgets/plant.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class cameraPage extends StatefulWidget {
  const cameraPage({super.key});
  @override
  State<cameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<cameraPage> {
  List<String> plants = [
    "Bell Pepper",
    "Cassava",
    "Grape",
    "Potato",
    "Strawberry",
    "Tomato",
  ];

  String getPlantName() {
    String currentplant = "";
    String mainString = _output?.elementAt(0)['label'] ?? '';
    for (var plant in plants) {
      if (mainString.contains(plant)) {
        currentplant = plant;
        break;
      }
    }
    return currentplant;
  }

  bool loading = true;
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
        numResults: 24,
        threshold: 0.4,
        asynch: true,
        imageMean: 0,
        imageStd: 1);
    setState(() {
      _output = output;
      loading = _output == null || _output!.isEmpty;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/picleaf_model_fp16.tflite',
        labels: 'assets/labels.txt',
        numThreads: 1);
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "PicLeaf",
          style: TextStyle(color: Colors.white, fontFamily: 'RobotoBold'),
        ),
        backgroundColor: const Color.fromRGBO(102, 204, 102, 1.0),
        shadowColor: const Color(0xffeeeeee),
      ),
      backgroundColor: const Color(0xffeeeeee),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Center(
              child: loading
                  ? SizedBox(
                      height: 300,
                      width: screenWidth * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/logoeee.png'),
                        ],
                      ),
                    )
                  : SizedBox(
                      width: screenWidth * 0.9,
                      child: Column(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.file(_image, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 10),
                          _output != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Leaf Detected:\n${_output?.elementAt(0)['label'] ?? 'Object cannot be identified.'}',
                                      style: const TextStyle(
                                          decorationColor:
                                              Color.fromRGBO(47, 79, 79, 1.0),
                                          fontSize: 15,
                                          fontFamily: 'RobotoMedium',
                                          color:
                                              Color.fromRGBO(47, 79, 79, 1.0),
                                          height: 1.5),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                102, 204, 102, 1.0),
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: MaterialButton(
                                            height: 50.0,
                                            minWidth: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                32.0, // Adjust the width to be half minus padding
                                            color: const Color.fromRGBO(
                                                102, 204, 102, 1.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              side: const BorderSide(
                                                color: Color.fromRGBO(
                                                    102, 204, 102, 1.0),
                                                width: 1,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SecondPage(
                                                              plantname:
                                                                  getPlantName())));
                                            },
                                            child: const Text(
                                              "More Info",
                                              style: TextStyle(
                                                fontFamily: 'RobotoBold',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text(
                'User Tip:\nMake sure that the picture is clear\nto maximize results.',
                style: TextStyle(
                    fontFamily: 'RobotoMedium',
                    fontSize: 18,
                    color: Color.fromRGBO(47, 79, 79, 1.0)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 77,
              decoration: const BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: pickImage,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 75,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Color.fromRGBO(47, 79, 79, 1.0),
                            size: 40,
                          ),
                        ),
                        const Text(
                          'Take a Photo',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'RobotoMedium',
                              color: Color.fromRGBO(47, 79, 79, 1.0)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: pickGalleryImage,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 75,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Icon(
                            Icons.add,
                            color: Color.fromRGBO(47, 79, 79, 1.0),
                            size: 40,
                          ),
                        ),
                        const Text(
                          'Add from Gallery',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'RobotoMedium',
                              color: Color.fromRGBO(47, 79, 79, 1.0)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
