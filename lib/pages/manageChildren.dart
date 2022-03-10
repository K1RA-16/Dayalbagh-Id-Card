import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dayalbaghidregistration/data/satsangiData.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';

Uint8List finger = Uint8List(0);
int code = 0;

class ManageChildren extends StatefulWidget {
  static const platform =
      const MethodChannel("com.example.dayalbaghidregistration/getBitmap");
  @override
  State<ManageChildren> createState() => _AddChildrenState();
}

class _AddChildrenState extends State<ManageChildren>
    with SingleTickerProviderStateMixin {
  int fingersLeft = 4;
  int index = satsangiListData.index;
  bool fingerData = false;
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

  File? imageFile;
  late Animation<double> _animation;
  late AnimationController _animationController;
  bool error = false;
  bool loading = false;
  int x = 1;
  //= File("assets/images/userDummyPhoto.png");
  @override
  void initState() {
    uidController = TextEditingController(
        text: satsangiListData.satsangiList[index].uid + "-C$x");
    mobileController = TextEditingController(
        text: satsangiListData.satsangiList[index].mobile);
    fatherNameController =
        TextEditingController(text: satsangiListData.satsangiList[index].name);
    nameController = TextEditingController();
    dobController = TextEditingController();

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
    if (image != null) imageFile = File(image.path);
    setState(() {});
  }

  initialiseReader() async {
    try {
      String x = await ManageChildren.platform.invokeMethod("initialiseReader");
      VxToast.show(context, msg: x);
      // ignore: empty_catches
    } on PlatformException catch (e) {}
  }

  startReading() async {
    //initialiseReader();
    setState(() {
      loading = true;
    });

    await ManageChildren.platform.invokeMethod("startReading");
  }

  getFingerprint(int fingerIso) async {
    try {
      final Uint8List result =
          await ManageChildren.platform.invokeMethod("getFingerprint");
      finger = result;
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
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildPopupretakeFingerprint(context, fingerIso));
        });
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

          fingerData = true;
        });
      }
    } on PlatformException catch (e) {}
  }

  int convertUint8ListToString(Uint8List uint8list) {
    if (String.fromCharCodes(uint8list) == "Improper Finger Placement") {
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
              VxToast.show(context, msg: "Details Updated");
              Navigator.pop(context);
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
                        finger,
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
                        finger,
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
                        finger,
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
                        finger,
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
                        finger,
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
                        finger,
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
            controller: mobileController,
            decoration: InputDecoration(
                label: Text("Parent Mobile Number"),
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
            controller: fatherNameController,
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
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildPopupFingerprint(context, fingerIso));
            startReading();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Scan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  primary: Colors.orange,
                ),
                onPressed: () {
                  if (fingersLeft != 0 ||
                      (fingersLeft == 0 && finger1 == true)) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupFingerprint(context, 1));
                    startReading();
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'finger 1',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (finger1) Icon(Icons.check, color: Colors.green),
                    ]),
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
                  if (fingersLeft != 0 ||
                      (fingersLeft == 0 && finger3 == true)) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupFingerprint(context, 3));
                    startReading();
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'finger 3',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (finger3) Icon(Icons.check, color: Colors.green),
                    ]),
              ),
            ),
          ],
        ),
        5.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  primary: Colors.orange,
                ),
                onPressed: () {
                  if (fingersLeft != 0 ||
                      (fingersLeft == 0 && finger2 == true)) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupFingerprint(context, 2));
                    startReading();
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'finger 2',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (finger2) Icon(Icons.check, color: Colors.green),
                    ]),
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
                  if (fingersLeft != 0 ||
                      (fingersLeft == 0 && finger4 == true)) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupFingerprint(context, 4));
                    startReading();
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'finger 4',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (finger4) Icon(Icons.check, color: Colors.green),
                    ]),
              ),
            ),
          ],
        ),
        5.heightBox,
        Text("scan finger 5 or 6 if index or middle finger cannot be used")
            .p(10),
        5.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  primary: Colors.orange,
                ),
                onPressed: () {
                  if (fingersLeft != 0 ||
                      (fingersLeft == 0 && finger5 == true)) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupFingerprint(context, 5));
                    startReading();
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'finger 5',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (finger5) Icon(Icons.check, color: Colors.green),
                    ]),
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
                  if (fingersLeft != 0 ||
                      (fingersLeft == 0 && finger6 == true)) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupFingerprint(context, 6));
                    startReading();
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'finger 6',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (finger6) Icon(Icons.check, color: Colors.green),
                    ]),
              ),
            ),
            5.heightBox,
          ],
        ),
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
                  Text(
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
}
