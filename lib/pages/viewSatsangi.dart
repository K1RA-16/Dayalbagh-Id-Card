import 'dart:convert';
import 'dart:typed_data';

import 'package:dayalbaghidregistration/data/SatsangiBiometricData.dart';
import 'package:dayalbaghidregistration/data/childBiometricViewData.dart';
import 'package:dayalbaghidregistration/data/satsangiData.dart';
import 'package:dayalbaghidregistration/data/satsangiGetBiometricData.dart';
import 'package:dayalbaghidregistration/pages/listSatsangis.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ViewSatsangi extends StatefulWidget {
  @override
  State<ViewSatsangi> createState() => _ViewSatsangiState();
}

class _ViewSatsangiState extends State<ViewSatsangi> {
  late TextEditingController uidController;
  late TextEditingController statusController;
  late TextEditingController genderController;
  late TextEditingController doisController;
  late TextEditingController fatherNameController;
  late TextEditingController regionController;
  late TextEditingController spouseNameController;
  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController doi1Controller;
  late TextEditingController doi2Controller;

  bool finger1 = false;
  bool finger2 = false;
  bool finger3 = false;
  bool finger4 = false;
  bool concent = false;
  bool faceImage = false;

  String fingerIso1 = "";
  String fingerIso2 = "";
  String fingerIso3 = "";
  String fingerIso4 = "";

  Uint8List fingerData1 = Uint8List(0);
  Uint8List fingerData2 = Uint8List(0);
  Uint8List fingerData3 = Uint8List(0);
  Uint8List fingerData4 = Uint8List(0);
  Uint8List imageFile = Uint8List(0);
  Uint8List concentFile = Uint8List(0);
  @override
  void initState() {
    setState(() {
      concent = false;
    });
    try {
      uidController =
          TextEditingController(text: SatsangiGetBiometricMap.data["uid"]);
      regionController = TextEditingController(
          text: satsangiListData.satsangiList[satsangiListData.index].region);
      genderController = TextEditingController(
          text: satsangiListData.satsangiList[satsangiListData.index].gender);
      spouseNameController = TextEditingController(
          text:
              satsangiListData.satsangiList[satsangiListData.index].spouseName);
      fatherNameController = TextEditingController(
          text:
              satsangiListData.satsangiList[satsangiListData.index].fatherName);
      nameController =
          TextEditingController(text: SatsangiGetBiometricMap.data["name"]);
      statusController =
          TextEditingController(text: SatsangiGetBiometricMap.data["status"]);

      doisController = TextEditingController(
          text: SatsangiGetBiometricMap.data["date_of_issue"]);
      dobController =
          TextEditingController(text: SatsangiGetBiometricMap.data["dob"]);
      doi1Controller = TextEditingController(
          text: SatsangiGetBiometricMap.data["doi_First"]);
      doi2Controller = TextEditingController(
          text: SatsangiGetBiometricMap.data["doi_Second"]);
    } on Exception catch (e) {
      // TODO
    }

    loadData();
    super.initState();
  }

  loadData() {
    try {
      loadIso(SatsangiGetBiometricMap.data["isO_FP_1"], 1);
      loadIso(SatsangiGetBiometricMap.data["isO_FP_2"], 2);
      loadIso(SatsangiGetBiometricMap.data["isO_FP_3"], 3);
      loadIso(SatsangiGetBiometricMap.data["isO_FP_4"], 4);
      // fingerData1 = base64Decode(SatsangiGetBiometricMap.data["fingerPrint_1"]);
      // fingerData2 = base64Decode(SatsangiGetBiometricMap.data["fingerPrint_2"]);
      // fingerData3 = base64Decode(SatsangiGetBiometricMap.data["fingerPrint_3"]);
      // fingerData4 = base64Decode(SatsangiGetBiometricMap.data["fingerPrint_4"]);
      imageFile = base64Decode(SatsangiGetBiometricMap.data["image"]);
      concentFile = base64Decode(SatsangiGetBiometricMap.data["concent"]);
      setState(() {
        concent = true;
      });
      try {
        if (SatsangiGetBiometricMap.data["image"].toString().length > 5)
          setState(() {
            faceImage = true;
          });
        if (SatsangiGetBiometricMap.data["concent"].toString().length > 5)
          setState(() {
            concent = true;
          });

        print(SatsangiGetBiometricMap.data["image"].toString().length);
        setState(() {});
      } on Exception catch (e) {
        // TODO
      }
    } on Exception catch (e) {
      // TODO
      print("check");
    }
  }

  loadIso(int key, int index) {
    String value = "";
    if (key == 2) {
      value = "Right index finger";
    } else if (key == 1) {
      value = "Right thumb finger";
    } else if (key == 3) {
      value = "Right middle finger";
    } else if (key == 4) {
      value = "Right ring finger";
    } else if (key == 7) {
      value = "Left index finger";
    } else if (key == 8) {
      value = "Left middle finger";
    } else if (key == 6) {
      value = "Left thumb finger";
    } else if (key == 9) {
      value = "Left ring finger";
    } else if (key == 10) {
      value = "Left baby finger";
    } else if (key == 5) {
      value = "Right baby finger";
    }
    if (index == 1) {
      fingerIso1 = value;
      finger1 = true;
    } else if (index == 2) {
      fingerIso2 = value;
      finger2 = true;
    } else if (index == 3) {
      fingerIso3 = value;
      finger3 = true;
    } else if (index == 4) {
      fingerIso4 = value;
      finger4 = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Satsangi Info".text.make(),
      ),
      // floatingActionButton: FloatingActionBubble(
      //   items: <Bubble>[
      //     Bubble(
      //       title: "Add Image",
      //       iconColor: Colors.black,
      //       bubbleColor: Colors.orange,
      //       icon: Icons.add_photo_alternate,
      //       titleStyle: TextStyle(fontSize: 16, color: Colors.black),
      //       onPress: () {
      //         initialiseCamera();
      //       },
      //     ),
      //     Bubble(
      //       title: "Add fingerprint",
      //       iconColor: Colors.black,
      //       bubbleColor: Colors.orange,
      //       icon: Icons.fingerprint,
      //       titleStyle: TextStyle(fontSize: 16, color: Colors.black),
      //       onPress: () {
      //         showDialog(
      //             context: context,
      //             builder: (BuildContext context) =>
      //                 _buildPopupShowFingers(context));
      //       },
      //     ),
      //   ],
      //   animation: _animation,

      //   // On pressed change animation state
      //   onPress: () => _animationController.isCompleted
      //       ? _animationController.reverse()
      //       : _animationController.forward(),

      //   // Floating Action button Icon color
      //   iconColor: Colors.black,

      //   // Flaoting Action button Icon
      //   iconData: Icons.add,
      //   backGroundColor: Colors.orange,
      // ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(children: [
          20.heightBox,
          if (concent) "Consent".text.bold.size(15).white.make(),
          if (concent)
            Card(
                color: Colors.orange.shade200,
                child: Column(children: [
                  5.heightBox,
                  Image.memory(
                    concentFile,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ).pOnly(bottom: 10),
                ])),
          if (faceImage) "Face Image".text.bold.size(15).white.make(),
          if (faceImage)
            Card(
                color: Colors.orange.shade200,
                child: Column(children: [
                  5.heightBox,
                  Image.memory(
                    imageFile,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ).pOnly(bottom: 10),
                ])),
          // CircleAvatar(
          //   radius: 100,
          //   backgroundImage: MemoryImage(imageFile),
          // ),
          5.heightBox,
          "FingerPrints".text.bold.size(15).make(),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (finger1)
                Card(
                  color: Colors.orange.shade200,
                  child: Column(
                    children: [
                      fingerIso1.text.black.make(),
                      5.heightBox,
                      Image.asset(
                        "assets/done.jpg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ).p(5),
                ),
              if (finger2)
                Card(
                  color: Colors.orange.shade200,
                  child: Column(
                    children: [
                      fingerIso2.text.black.make(),
                      5.heightBox,
                      Image.asset(
                        "assets/done.jpg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ).p(5),
                ),
            ],
          ),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (finger3)
                Card(
                  color: Colors.orange.shade200,
                  child: Column(
                    children: [
                      fingerIso3.text.black.make(),
                      5.heightBox,
                      Image.asset(
                        "assets/done.jpg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ).p(5),
                ),
              if (finger4)
                Card(
                  color: Colors.orange.shade200,
                  child: Column(
                    children: [
                      fingerIso4.text.black.make(),
                      5.heightBox,
                      Image.asset(
                        "assets/done.jpg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ).p(5),
                ),
            ],
          ),
          20.heightBox,
          TextField(
            readOnly: true,
            controller: uidController,
            decoration: InputDecoration(
                label: Text("UID"),
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                )),
          ),
          20.heightBox,
          TextField(
            readOnly: true,
            controller: nameController,
            decoration: InputDecoration(
                label: Text("Name"),
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                )),
          ),

          20.heightBox,
          TextField(
            readOnly: true,
            controller: dobController,
            decoration: InputDecoration(
                label: Text("Date Of Birth"),
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                )),
          ),
          20.heightBox,
          TextField(
            readOnly: true,
            controller: spouseNameController,
            decoration: InputDecoration(
                label: Text("Spouse Name"),
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                )),
          ),
          20.heightBox,
          TextField(
            readOnly: true,
            controller: fatherNameController,
            decoration: InputDecoration(
                label: Text("Father Name"),
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                )),
          ),
          20.heightBox,
          TextField(
            readOnly: true,
            controller: regionController,
            decoration: InputDecoration(
                label: Text("Region Name"),
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                )),
          ),
          20.heightBox,
          TextField(
            readOnly: true,
            controller: genderController,
            decoration: InputDecoration(
                label: Text("Gender"),
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                )),
          ),
          20.heightBox,
          TextField(
            readOnly: true,
            controller: doisController,
            decoration: InputDecoration(
                label: Text("Date Of Issue"),
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                )),
          ),
          20.heightBox,
        ]).p(10),
      ),
    );
  }
}
