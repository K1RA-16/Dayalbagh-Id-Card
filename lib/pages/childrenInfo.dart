import 'dart:io';
import 'dart:typed_data';

import 'package:dayalbaghidregistration/data/satsangiData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

Uint8List finger = Uint8List(1);

class ChildrenInfo extends StatefulWidget {
  static const platform =
      const MethodChannel("com.example.dayalbaghidregistration/getBitmap");
  @override
  State<ChildrenInfo> createState() => _ChildrenInfoState();
}

class _ChildrenInfoState extends State<ChildrenInfo>
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
      await ChildrenInfo.platform.invokeMethod("initialiseReader");
      // ignore: empty_catches
    } on PlatformException catch (e) {}
  }

  getFingerprint() async {
    try {
      final Uint8List result =
          await ChildrenInfo.platform.invokeMethod("getFingerprint");
      finger = result;
      setState(() {
        fingerData = true;
      });
    } on PlatformException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        20.heightBox,
        Row(
          children: [
            if (imageFile != null)
              CircleAvatar(
                radius: 100,
                backgroundImage: FileImage(imageFile!),
              ),
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
    );
  }
}
