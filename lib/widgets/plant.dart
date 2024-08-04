import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picleaf/models/plant_display.dart';
import 'package:flutter/material.dart';
import 'package:picleaf/widgets/plantdiseasecard.dart';

class SecondPage extends StatefulWidget {
  final String plantname;
  const SecondPage({Key? key, required this.plantname}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<Object> _plantdiseaseList = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getPlantDiseaseList();
  }

  @override
  Widget build(BuildContext context) {
    final String pname = widget.plantname;
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            "Diseases of $pname",
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "RobotoBold"),
          ),
          backgroundColor: const Color.fromRGBO(102, 204, 102, 1.0),
          shadowColor: const Color(0xffeeeeee),
        ),
        body: SafeArea(
            child: Container(
          color: const Color(0xffeeeeee),
          child: ListView.builder(
            itemCount: _plantdiseaseList.length,
            itemBuilder: (context, index) {
              return PlantCard(_plantdiseaseList[index] as PlantDisplay);
            },
            padding: const EdgeInsets.only(top: 10),
          ),
        )));
  }

  Future getPlantDiseaseList() async {
    var data =
        await FirebaseFirestore.instance.collection(widget.plantname).get();
    setState(() {
      _plantdiseaseList =
          List.from(data.docs.map((doc) => PlantDisplay.fromSnapshot(doc)));
    });
  }
}
