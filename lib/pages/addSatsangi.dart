import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:dayalbaghidregistration/apiAccess/postApis.dart';
import 'package:dayalbaghidregistration/data/satsangiData.dart';
import 'package:dayalbaghidregistration/pages/listSatsangis.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';

Uint8List fingerData1 = Uint8List(0);
Uint8List fingerData2 = Uint8List(0);
Uint8List fingerData3 = Uint8List(0);
Uint8List fingerData4 = Uint8List(0);
Uint8List fingerData5 = Uint8List(0);
Uint8List fingerData6 = Uint8List(0);
int code = 0;
//Uint8List testImage = Uint8List(0);

class AddSatsangi extends StatefulWidget {
  static const platform =
      const MethodChannel("com.example.dayalbaghidregistration/getBitmap");
  @override
  State<AddSatsangi> createState() => _AddSatsangiState();
}

class _AddSatsangiState extends State<AddSatsangi>
    with SingleTickerProviderStateMixin {
  int fingerScanned = 0;
  int index = satsangiListData.index;
  bool photoTaken = false;
  bool finger1 = false;
  bool finger2 = false;
  bool finger3 = false;
  bool finger4 = false;
  bool finger5 = false;
  bool finger6 = false;

  List<int> iso = [];
  List<String> fingerprints = [];
  String faceImage = "";

  late TextEditingController uidController;
  late TextEditingController mobileController;
  late TextEditingController fatherNameController;
  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController doi1Controller;
  late TextEditingController doi2Controller;

  File? imageFile;

  late Animation<double> _animation;
  late AnimationController _animationController;
  bool error = false;
  bool loading = false;
  //= File("assets/images/userDummyPhoto.png");
  @override
  void initState() {
    uidController =
        TextEditingController(text: satsangiListData.satsangiList[index].uid);
    mobileController = TextEditingController(
        text: satsangiListData.satsangiList[index].mobile);
    fatherNameController = TextEditingController(
        text: satsangiListData.satsangiList[index].father_Or_Spouse_Name);
    nameController =
        TextEditingController(text: satsangiListData.satsangiList[index].name);
    dobController =
        TextEditingController(text: satsangiListData.satsangiList[index].dob);
    doi1Controller = TextEditingController(
        text: satsangiListData.satsangiList[index].doi_First);
    doi2Controller = TextEditingController(
        text: satsangiListData.satsangiList[index].doi_Second);
    initialiseReader();
    //getImage();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  initialiseCamera() async {
    // TODO: implement initState
    final ImagePicker _picker = ImagePicker();

    // Capture a photo
    var image = await _picker.getImage(source: ImageSource.camera);
    if (image != null) {
      imageFile = File(image.path);
      photoTaken = true;
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupImage(context));
    }
    Uint8List imagebytes = await image!.readAsBytes(); //convert to bytes
    faceImage = base64.encode(imagebytes); //convert bytes to base64 string
    print(faceImage);
    setState(() {});
  }

  //getImage() async {
  //  testImage = await PostApi().getTestImage();
  //   setState(() {});
  // }

  initialiseReader() async {
    try {
      String x = await AddSatsangi.platform.invokeMethod("initialiseReader");
      VxToast.show(context, msg: x);

      // ignore: empty_catches
    } on PlatformException catch (e) {}
  }

  startReading() async {
    //initialiseReader();
    setState(() {
      loading = true;
    });

    await AddSatsangi.platform.invokeMethod("startReading");
  }

  getFingerprint(int fingerIso) async {
    try {
      final Uint8List result =
          await AddSatsangi.platform.invokeMethod("getFingerprint");
      if (fingerIso == 1) {
        fingerData1 = result;
      } else if (fingerIso == 2) {
        fingerData2 = result;
      } else if (fingerIso == 3) {
        fingerData3 = result;
      } else if (fingerIso == 4) {
        fingerData4 = result;
      } else if (fingerIso == 5) {
        fingerData5 = result;
      } else if (fingerIso == 6) {
        fingerData6 = result;
      }
      int code = convertUint8ListToString(result);

      if (code == 0) {
        setState(() {
          loading = false;
          if (fingerIso == 1) {
            finger1 = false;
          } else if (fingerIso == 2) {
            finger2 = false;
          } else if (fingerIso == 3) {
            finger3 = false;
          } else if (fingerIso == 4) {
            finger4 = false;
          } else if (fingerIso == 5) {
            finger5 = false;
          } else if (fingerIso == 6) {
            finger6 = false;
          }
        });
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                _buildPopupretakeFingerprint(context, fingerIso));
      }

      if (result.isNotEmpty && code == 1) {
        setState(() {
          Navigator.pop(context);

          print("finger iso $fingerIso");
          Navigator.pop(context);

          if (fingerIso == 1) {
            if (!finger1) {
              fingerScanned++;
            }

            finger1 = true;
            showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupFinger1(context));
          } else if (fingerIso == 2) {
            if (!finger2) {
              fingerScanned++;
            }
            finger2 = true;
            showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupFinger2(context));
          } else if (fingerIso == 3) {
            if (!finger3) {
              fingerScanned++;
            }
            finger3 = true;
            showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupFinger3(context));
          } else if (fingerIso == 4) {
            if (!finger4) {
              fingerScanned++;
            }
            finger4 = true;
            showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupFinger4(context));
          } else if (fingerIso == 5) {
            if (!finger5) {
              fingerScanned++;
            }
            finger5 = true;
            showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupFinger5(context));
          } else if (fingerIso == 6) {
            if (!finger6) {
              fingerScanned++;
            }
            finger6 = true;
            showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupFinger6(context));
          }

          setState(() {});
          loading = false;
        });
      }
    } on PlatformException catch (e) {}
  }

  int convertUint8ListToString(Uint8List uint8list) {
    print(String.fromCharCodes(uint8list));
    if (String.fromCharCodes(uint8list) == "Improper Finger Placement") {
      return 0;
    } else if (String.fromCharCodes(uint8list) == "No Device Connected") {
      Navigator.pop(context);
      VxToast.show(context, msg: "please connect the device properly");
      return 2;
    } else if (String.fromCharCodes(uint8list) == "Capturing stopped") {
      Navigator.pop(context);
      VxToast.show(context, msg: "please wait until the scanner stops reading");
      return 2;
    } else {
      return 1;
    }
  }

  resetData() {
    setState(() {
      imageFile = null;
      finger1 = finger2 = finger3 = finger4 = finger5 = finger6 = false;
      fingerScanned = 0;
    });
  }

  updateData() async {
    PostApi().updateBiometric(
        satsangiListData.satsangiList[satsangiListData.index].uid,
        iso[0],
        iso[1],
        iso[2],
        iso[3],
        fingerprints[0],
        fingerprints[1],
        fingerprints[2],
        fingerprints[3],
        faceImage);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Registration".text.make(),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.black,
            ),
            onPressed: () {
              //VxToast.show(context, msg: "Details Updated");
              print(iso);
              print(fingerprints);
              if (fingerprints.length == 4 &&
                  iso.length == 4 &&
                  faceImage != "") {
                updateData();
                VxToast.show(context, msg: "details updated");
              } else {
                VxToast.show(context,
                    msg: "error updating (try again after resetting data)");
              }
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Done',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  5.widthBox,
                  Icon(Icons.forward, color: Colors.green),
                ]),
          ).p(5),
        ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  primary: Colors.orange,
                ),
                onPressed: () {
                  //VxToast.show(context, msg: "Details Updated");
                  resetData();
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Reset all info',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      5.widthBox,
                      Icon(Icons.restore, color: Colors.green),
                    ]),
              ).p(5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  primary: Colors.orange,
                ),
                onPressed: () {
                  //VxToast.show(context, msg: "Details Updated");
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupImage(context));
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Update Info',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      5.widthBox,
                      Icon(Icons.update, color: Colors.green),
                    ]),
              ).p(5),
            ],
          ),
          10.heightBox,
          if (imageFile != null)
            CircleAvatar(
              radius: 100,
              backgroundImage: FileImage(imageFile!),
            ),
          if (imageFile == null)
            InkWell(
              onTap: () {
                initialiseCamera();
              },
              child: CircleAvatar(
                radius: 100,
                child: Image.asset("assets/addPhoto.png"),
              ),
            ),
          5.heightBox,
          if (finger1 || finger2) "Left hand finger prints".text.make(),
          5.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (finger1)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "left index finger".text.black.make(),
                      5.heightBox,
                      Image.memory(
                        fingerData1,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ).p(5),
                ),
              if (finger3)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "left middle finger".text.black.make(),
                      5.heightBox,
                      Image.memory(
                        fingerData3,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ).p(5),
                ),
            ],
          ),
          5.heightBox,
          if (finger3 || finger4) "Right hand finger prints".text.make(),
          5.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (finger2)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "right index finger".text.black.make(),
                      5.heightBox,
                      Image.memory(
                        fingerData2,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ).p(5),
                ),
              if (finger4)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "Right middle finger".text.black.make(),
                      5.heightBox,
                      Image.memory(
                        fingerData4,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ).p(5),
                ),
            ],
          ),
          if (finger5 || finger6) "Ring finger prints".text.make(),
          5.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (finger5)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "left ring finger".text.black.make(),
                      5.heightBox,
                      Image.memory(
                        fingerData5,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ).p(5),
                ),
              if (finger6)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "Right ring finger".text.black.make(),
                      5.heightBox,
                      Image.memory(
                        fingerData6,
                        width: 100,
                        height: 100,
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
            controller: mobileController,
            decoration: InputDecoration(
                label: Text("Mobile Number"),
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
                label: Text("Father / Husband Name"),
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
            controller: doi1Controller,
            decoration: InputDecoration(
                label: Text("Date Of First Initiation"),
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
            controller: doi2Controller,
            decoration: InputDecoration(
                label: Text("Date Of First Initiation"),
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

  Widget _buildPopupretakeFingerprint(BuildContext context, int fingerIso) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Improper finger placement Please take the scan again"),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Colors.orange,
          ),
          onPressed: () {
            Navigator.pop(context);
            //print("re read iso $fingerIso");
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildPopupFingerprint(context, fingerIso));
            startReading();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Scan again',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupFinger1(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingerScanned Fingers Scanned"),
      actions: <Widget>[
        Center(
          child: Container(
            width: 250,
            height: 250,
            child: Image.asset(
              "assets/LI.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        5.heightBox,
        if (finger1)
          Center(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.memory(
                    fingerData1,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ],
              ).p(5),
            ),
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              finger1 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint(context, 1));
              startReading();
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  finger1
                      ? const Text(
                          'Re-scan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      : const Text(
                          'Start Scanning',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ]),
          ),
        ),
        5.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupFinger2(context));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'finger not available',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ]),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                if (finger1) {
                  Navigator.pop(context);
                  iso.add(7);
                  fingerprints.add(base64.encode(fingerData1));
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupFinger2(context));
                } else {
                  VxToast.show(context,
                      msg:
                          "Please scan the finger or select finger not available");
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (finger1) Icon(Icons.check, color: Colors.green),
                  ]),
            ),
            5.heightBox,
          ],
        ),
      ],
    );
  }

  Widget _buildPopupFinger2(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingerScanned Finger Scanned"),
      actions: <Widget>[
        Center(
          child: Container(
            width: 250,
            height: 250,
            child: Image.asset(
              "assets/RI.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        5.heightBox,
        if (finger2)
          Center(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.memory(
                    fingerData2,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ],
              ).p(5),
            ),
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              finger2 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint(context, 2));
              startReading();
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  finger2
                      ? const Text(
                          'Re-scan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      : const Text(
                          'Start Scanning',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ]),
          ),
        ),
        5.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupFinger3(context));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'finger not available',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ]),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                if (finger2) {
                  iso.add(2);
                  fingerprints.add(base64.encode(fingerData2));
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupFinger3(context));
                } else {
                  VxToast.show(context,
                      msg:
                          "Please scan the finger or select finger not available");
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (finger2) Icon(Icons.check, color: Colors.green),
                  ]),
            ),
            5.heightBox,
          ],
        ),
      ],
    );
  }

  Widget _buildPopupFinger3(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingerScanned Finger Scanned"),
      actions: <Widget>[
        Center(
          child: Container(
            width: 250,
            height: 250,
            child: Image.asset(
              "assets/LM.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        5.heightBox,
        if (finger3)
          Center(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.memory(
                    fingerData3,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ],
              ).p(5),
            ),
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              finger3 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint(context, 3));
              startReading();
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  finger3
                      ? const Text(
                          'Re-scan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      : const Text(
                          'Start Scanning',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ]),
          ),
        ),
        5.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupFinger4(context));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'finger not available',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ]),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                if (finger3) {
                  iso.add(8);
                  fingerprints.add(base64.encode(fingerData3));
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupFinger4(context));
                } else {
                  VxToast.show(context,
                      msg:
                          "Please scan the finger or select finger not available");
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (finger3) Icon(Icons.check, color: Colors.green),
                  ]),
            ),
            5.heightBox,
          ],
        ),
      ],
    );
  }

  Widget _buildPopupFinger4(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingerScanned Finger Scanned"),
      actions: <Widget>[
        Center(
          child: Container(
            width: 250,
            height: 250,
            child: Image.asset(
              "assets/RM.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        5.heightBox,
        if (finger4)
          Center(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.memory(
                    fingerData4,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ],
              ).p(5),
            ),
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              finger4 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint(context, 4));
              startReading();
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  finger4
                      ? const Text(
                          'Re-scan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      : const Text(
                          'Start Scanning',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ]),
          ),
        ),
        5.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupFinger5(context));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'finger not available',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ]),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                if (finger4 && fingerScanned < 4) {
                  iso.add(3);
                  fingerprints.add(base64.encode(fingerData4));
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupFinger5(context));
                } else if (fingerScanned >= 4) {
                  Navigator.pop(context);
                  iso.add(3);
                  fingerprints.add(base64.encode(fingerData4));
                } else {
                  VxToast.show(context,
                      msg:
                          "Please scan the finger or select finger not available");
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (finger4) Icon(Icons.check, color: Colors.green),
                  ]),
            ),
            5.heightBox,
          ],
        ),
      ],
    );
  }

  Widget _buildPopupFinger5(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingerScanned Finger Scanned"),
      actions: <Widget>[
        Center(
          child: Container(
            width: 250,
            height: 250,
            child: Image.asset(
              "assets/LR.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        5.heightBox,
        if (finger5)
          Center(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.memory(
                    fingerData5,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ],
              ).p(5),
            ),
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              finger5 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint(context, 5));
              startReading();
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  finger5
                      ? const Text(
                          'Re-scan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      : const Text(
                          'Start Scanning',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ]),
          ),
        ),
        5.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                if (finger5 && fingerScanned < 4) {
                  iso.add(9);
                  fingerprints.add(base64.encode(fingerData5));
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupFinger6(context));
                } else if (fingerScanned >= 4) {
                  Navigator.pop(context);
                } else {
                  VxToast.show(context,
                      msg:
                          "Please scan the finger or select finger not available");
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (finger5) Icon(Icons.check, color: Colors.green),
                  ]),
            ),
            5.heightBox,
          ],
        ),
      ],
    );
  }

  Widget _buildPopupFinger6(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingerScanned Finger Scanned"),
      actions: <Widget>[
        Center(
          child: Container(
            width: 250,
            height: 250,
            child: Image.asset(
              "assets/RI.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        5.heightBox,
        if (finger6)
          Center(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.memory(
                    fingerData6,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ],
              ).p(5),
            ),
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              finger6 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint(context, 6));
              startReading();
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  finger6
                      ? const Text(
                          'Re-scan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      : const Text(
                          'Start Scanning',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ]),
          ),
        ),
        5.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                if (finger6 || fingerScanned >= 4) {
                  iso.add(4);
                  fingerprints.add(base64.encode(fingerData6));
                  Navigator.pop(context);
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (finger6) Icon(Icons.check, color: Colors.green),
                  ]),
            ),
            5.heightBox,
          ],
        ),
      ],
    );
  }

  Widget _buildPopupFingerprint(BuildContext context, int fingerIso) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Please retrieve to check the image"),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Colors.orange,
          ),
          onPressed: () {
            getFingerprint(fingerIso);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Get Scan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupImage(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Please take a photo"),
      actions: <Widget>[
        if (imageFile != null)
          Center(
            child: CircleAvatar(
              radius: 100,
              backgroundImage: FileImage(imageFile!),
            ),
          ),
        10.heightBox,
        Center(
          child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  primary: Colors.orange,
                ),
                onPressed: () {
                  initialiseCamera();
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: photoTaken
                      ? Text(
                          'Retake photo',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      : Text(
                          "Capture",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ),
              ),
              10.heightBox,
              if (photoTaken)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupFinger1(context));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Next",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
