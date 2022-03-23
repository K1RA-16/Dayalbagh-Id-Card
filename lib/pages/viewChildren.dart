import 'dart:convert';
import 'dart:typed_data';

import 'package:dayalbaghidregistration/data/childBiometricViewData.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ViewChildren extends StatefulWidget {
  @override
  State<ViewChildren> createState() => _ViewChildrenState();
}

class _ViewChildrenState extends State<ViewChildren> {
  late TextEditingController uidController;

  late TextEditingController parentNameController;

  late TextEditingController nameController;

  late TextEditingController dobController;

  late TextEditingController uid1Controller;

  late TextEditingController uid2Controller;
  late TextEditingController genderController;
  late TextEditingController firstCreatedController;

  bool finger1 = false;
  bool finger2 = false;
  bool finger3 = false;
  bool finger4 = false;

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

  @override
  void initState() {
    try {
      uidController =
          TextEditingController(text: ChildBiometricData.data["uid"]);

      parentNameController =
          TextEditingController(text: ChildBiometricData.data["father_name"]);
      genderController =
          TextEditingController(text: ChildBiometricData.data["gender"]);
      firstCreatedController =
          TextEditingController(text: ChildBiometricData.data["first_created"]);
      nameController =
          TextEditingController(text: ChildBiometricData.data["name"]);
      dobController =
          TextEditingController(text: ChildBiometricData.data["dob"]);
      uid1Controller = TextEditingController(
          text: ChildBiometricData.data["parent_uid_one"]);
      uid2Controller = TextEditingController(
          text: ChildBiometricData.data["parent_uid_two"]);
    } on Exception catch (e) {
      // TODO
    }
    loadData();
    super.initState();
  }

  loadData() {
    try {
      loadIso(ChildBiometricData.data["isO_FP_1"]!, 1);
      loadIso(ChildBiometricData.data["isO_FP_2"]!, 2);
      loadIso(ChildBiometricData.data["isO_FP_3"]!, 3);
      loadIso(ChildBiometricData.data["isO_FP_4"]!, 4);
      // fingerData1 = base64Decode(ChildBiometricData.data["fingerPrint_1"]);
      // fingerData2 = base64Decode(ChildBiometricData.data["fingerPrint_2"]);
      // fingerData3 = base64Decode(ChildBiometricData.data["fingerPrint_3"]);
      // fingerData4 = base64Decode(ChildBiometricData.data["fingerPrint_4"]);
      imageFile = base64Decode(ChildBiometricData.data["image"]);
      try {
        if (ChildBiometricData.data["image"].toString().length > 5)
          faceImage = true;
      } on Exception catch (e) {
        // TODO
      }
    } on Exception catch (e) {
      // TODO
    }
  }

  loadIso(int key, int index) {
    String value = "";
    if (key == 2) {
      value = "Right index finger";
    } else if (key == 3) {
      value = "Right middle finger";
    } else if (key == 4) {
      value = "Right ring finger";
    } else if (key == 7) {
      value = "Left index finger";
    } else if (key == 8) {
      value = "Left middle finger";
    } else if (key == 9) {
      value = "Left ring finger";
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
        title: "Child Info".text.make(),
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
          if (faceImage)
            Card(
                color: Colors.orange.shade200,
                child: Column(children: [
                  "Face Image".text.black.make(),
                  5.heightBox,
                  Image.memory(
                    imageFile,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ).p(10),
                ])),
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
            controller: parentNameController,
            decoration: InputDecoration(
                label: Text("Parent Name"),
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
            controller: uid1Controller,
            decoration: InputDecoration(
                label: Text("Uid Of First Parent"),
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
            controller: uid2Controller,
            decoration: InputDecoration(
                label: Text("Uid of Second Parent"),
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
            controller: firstCreatedController,
            decoration: InputDecoration(
                label: Text("Date of creation"),
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
