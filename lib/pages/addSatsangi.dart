import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dayalbaghidregistration/data/satsangiData.dart';
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

class AddSatsangi extends StatefulWidget {
  static const platform =
      const MethodChannel("com.example.dayalbaghidregistration/getBitmap");
  @override
  State<AddSatsangi> createState() => _AddSatsangiState();
}

class _AddSatsangiState extends State<AddSatsangi>
    with SingleTickerProviderStateMixin {
  int fingersLeft = 4;
  int index = satsangiListData.index;
  bool photoTaken = false;
  bool finger1 = false;
  bool finger2 = false;
  bool finger3 = false;
  bool finger4 = false;
  bool finger5 = false;
  bool finger6 = false;
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
    setState(() {});
  }

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
          if (fingersLeft != 0) {
            print("finger iso $fingerIso");
            if (fingerIso == 1) {
              if (!finger1) {
                fingersLeft--;
              }
              finger1 = true;
            } else if (fingerIso == 2) {
              if (!finger2) {
                fingersLeft--;
              }
              finger2 = true;
            } else if (fingerIso == 3) {
              if (!finger3) {
                fingersLeft--;
              }
              finger3 = true;
            } else if (fingerIso == 4) {
              if (!finger4) {
                fingersLeft--;
              }
              finger4 = true;
            } else if (fingerIso == 5) {
              if (!finger5) {
                fingersLeft--;
              }
              finger5 = true;
            } else if (fingerIso == 6) {
              if (!finger6) {
                fingersLeft--;
              }
              finger6 = true;
            }
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildPopupShowFingers(context));
          }
          setState(() {});
          loading = false;
        });
      }
    } on PlatformException catch (e) {}
  }

  int convertUint8ListToString(Uint8List uint8list) {
    if (String.fromCharCodes(uint8list) == "Improper Finger Placement") {
      fingersLeft++;
      return 0;
    } else {
      return 1;
    }
  }

  resetFingerData() {
    Navigator.pop(context);
    setState(() {
      finger1 = finger2 = finger3 = finger4 = finger5 = finger6 = false;
      fingersLeft = 4;
    });
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
              showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupImage(context));
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Update Info',
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
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "Add Image",
            iconColor: Colors.black,
            bubbleColor: Colors.orange,
            icon: Icons.add_photo_alternate,
            titleStyle: TextStyle(fontSize: 16, color: Colors.black),
            onPress: () {
              initialiseCamera();
            },
          ),
          Bubble(
            title: "Add fingerprint",
            iconColor: Colors.black,
            bubbleColor: Colors.orange,
            icon: Icons.fingerprint,
            titleStyle: TextStyle(fontSize: 16, color: Colors.black),
            onPress: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupShowFingers(context));
            },
          ),
        ],
        animation: _animation,

        // On pressed change animation state
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),

        // Floating Action button Icon color
        iconColor: Colors.black,

        // Flaoting Action button Icon
        iconData: Icons.add,
        backGroundColor: Colors.orange,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(children: [
          20.heightBox,
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
          if (finger1 || finger2 || finger5)
            "Left hand finger prints".text.make(),
          5.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (finger2)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "left index finger".text.black.make(),
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
              if (finger1)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "left middle finger".text.black.make(),
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
              if (finger5)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "left thumb".text.black.make(),
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
            ],
          ),
          5.heightBox,
          if (finger3 || finger4 || finger6)
            "Right hand finger prints".text.make(),
          5.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (finger3)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "right index finger".text.black.make(),
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
              if (finger4)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "left middle finger".text.black.make(),
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
              if (finger6)
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      "left thumb".text.black.make(),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingersLeft Finger Scans Left"),
      actions: <Widget>[
        Image.asset(
          "assets/LI.png",
          fit: BoxFit.contain,
        ),
        5.heightBox,
        if (finger1)
          Card(
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
        5.heightBox,
        Center(
          child: ElevatedButton(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger1) Icon(Icons.check, color: Colors.green),
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
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (finger1) Icon(Icons.check, color: Colors.green),
                  ]),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
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
                    const Text(
                      'Start Scanning',
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingersLeft Finger Scans Left"),
      actions: <Widget>[
        Image.asset(
          "assets/RI.png",
          fit: BoxFit.contain,
        ),
        5.heightBox,
        if (finger2)
          Card(
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
        5.heightBox,
        Center(
          child: ElevatedButton(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger2) Icon(Icons.check, color: Colors.green),
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
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (finger2) Icon(Icons.check, color: Colors.green),
                  ]),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
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
                    const Text(
                      'Start Scanning',
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingersLeft Finger Scans Left"),
      actions: <Widget>[
        Image.asset(
          "assets/LM.png",
          fit: BoxFit.contain,
        ),
        5.heightBox,
        if (finger3)
          Card(
            color: Colors.white,
            child: Column(
              children: [
                "right index finger".text.black.make(),
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
        5.heightBox,
        Center(
          child: ElevatedButton(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger3) Icon(Icons.check, color: Colors.green),
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
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (finger3) Icon(Icons.check, color: Colors.green),
                  ]),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                if (fingersLeft != 0 || (fingersLeft == 0 && finger3 == true)) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupFingerprint(context, 3));
                  startReading();
                }
                if (fingersLeft == 0 && finger3 == false) {
                  VxToast.show(context,
                      msg: "try resetting if ther are no more scans left");
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Start Scanning',
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingersLeft Finger Scans Left"),
      actions: <Widget>[
        Image.asset(
          "assets/RM.png",
          fit: BoxFit.contain,
        ),
        5.heightBox,
        if (finger4)
          Card(
            color: Colors.white,
            child: Column(
              children: [
                "left middle finger".text.black.make(),
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
        5.heightBox,
        Center(
          child: ElevatedButton(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger4) Icon(Icons.check, color: Colors.green),
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
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (finger4) Icon(Icons.check, color: Colors.green),
                  ]),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                if (fingersLeft != 0 || (fingersLeft == 0 && finger4 == true)) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupFingerprint(context, 4));
                  startReading();
                }
                if (fingersLeft == 0 && finger4 == false) {
                  VxToast.show(context,
                      msg: "try resetting if ther are no more scans left");
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Start Scanning',
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingersLeft Finger Scans Left"),
      actions: <Widget>[
        Image.asset(
          "assets/LR.png",
          fit: BoxFit.contain,
        ),
        5.heightBox,
        if (finger5)
          Card(
            color: Colors.white,
            child: Column(
              children: [
                "left thumb".text.black.make(),
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
                        _buildPopupFinger6(context));
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                if (fingersLeft != 0 || (fingersLeft == 0 && finger5 == true)) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupFingerprint(context, 5));
                  startReading();
                }
                if (fingersLeft == 0 && finger5 == false) {
                  VxToast.show(context,
                      msg: "try resetting if ther are no more scans left");
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Start Scanning',
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingersLeft Finger Scans Left"),
      actions: <Widget>[
        Image.asset(
          "assets/RR.png",
          fit: BoxFit.contain,
        ),
        5.heightBox,
        if (finger6)
          Card(
            color: Colors.white,
            child: Column(
              children: [
                "left thumb".text.black.make(),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                if (fingersLeft != 0 || (fingersLeft == 0 && finger6 == true)) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupFingerprint(context, 6));
                  startReading();
                }
                if (fingersLeft == 0 && finger6 == false) {
                  VxToast.show(context,
                      msg: "try resetting if ther are no more scans left");
                }
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Start Scanning',
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

  Widget _buildPopupShowFingers(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("$fingersLeft Finger Scans Left"),
      actions: <Widget>[
        Image.asset(
          "assets/fingers.png",
          fit: BoxFit.contain,
        ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              resetFingerData();
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Reset finger scans',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Icon(Icons.settings_backup_restore_outlined,
                      color: Colors.black),
                ]),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupFingerprint(BuildContext context, int fingerIso) {
    return AlertDialog(
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
