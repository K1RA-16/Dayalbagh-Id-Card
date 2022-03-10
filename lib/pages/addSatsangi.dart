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

class AddSatsangi extends StatefulWidget {
  static const platform =
      const MethodChannel("com.example.dayalbaghidregistration/getBitmap");
  @override
  State<AddSatsangi> createState() => _AddSatsangiState();
}

class _AddSatsangiState extends State<AddSatsangi>
    with SingleTickerProviderStateMixin {
  int index = satsangiListData.index;
  bool fingerData = false;
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
    if (image != null) imageFile = File(image.path);
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

  getFingerprint() async {
    try {
      final Uint8List result =
          await AddSatsangi.platform.invokeMethod("getFingerprint");
      finger = result;
      int code = convertUint8ListToString(result);
      if (code == 0) {
        setState(() {
          loading = false;
          fingerData = false;
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildPopupretakeFingerprint(context));
        });
      }
      if (result.isNotEmpty && code == 1) {
        setState(() {
          loading = false;
          Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "User Registration".text.make(),
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
            icon: Icons.add_photo_alternate,
            titleStyle: TextStyle(fontSize: 16, color: Colors.black),
            onPress: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint(context));
              startReading();
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
          Row(
            children: [
              if (imageFile != null)
                CircleAvatar(
                  radius: 100,
                  backgroundImage: FileImage(imageFile!),
                ),
              // if (code == 1)
              //   Image.network(
              //       "https://www.iconspng.com/uploads/right-or-wrong-5/right-or-wrong-5.png"),
              // if (code == 2)
              //   Image.network(
              //       "https://www.iconspng.com/uploads/right-or-wrong-4/right-or-wrong-4.png"),
              // if (code == 3)
              //   Image.network(
              //       "https://techxb.com/wp-content/uploads/2013/08/Social-Med-gone-badly-wrong.jpeg"),
              if (fingerData)
                Image.memory(
                  finger,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
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

  Widget _buildPopupretakeFingerprint(BuildContext context) {
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
                    _buildPopupFingerprint(context));
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

  Widget _buildPopupFingerprint(BuildContext context) {
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
            getFingerprint();
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
