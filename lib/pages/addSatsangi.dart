import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
//column in nexxt and finger not available
//next double check
import 'package:dayalbaghidregistration/apiAccess/postApis.dart';
import 'package:dayalbaghidregistration/data/fingerData.dart';
import 'package:dayalbaghidregistration/data/satsangiData.dart';
import 'package:dayalbaghidregistration/pages/addChild.dart';
import 'package:dayalbaghidregistration/pages/listSatsangis.dart';
import 'package:dayalbaghidregistration/utils/methodChannels.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';

import '../apiAccess/firebaseLogApis.dart';
import '../data/satsangiGetBiometricData.dart';

bool dialogLoading = false;
Uint8List fingerData1 = Uint8List(0);
Uint8List fingerData2 = Uint8List(0);
Uint8List fingerData3 = Uint8List(0);
Uint8List fingerData4 = Uint8List(0);
Uint8List fingerData5 = Uint8List(0);
Uint8List fingerData6 = Uint8List(0);
Uint8List fingerData7 = Uint8List(0);
Uint8List fingerData8 = Uint8List(0);
Uint8List fingerData9 = Uint8List(0);
Uint8List fingerData10 = Uint8List(0);

late FingerData fingerTemp1;
late FingerData fingerTemp2;
int code = 0;
bool faceLoading = false;
bool consentLoading = false;
bool rescan = false;
Map<int, String> fingerIsoMap = {
  1: "Left index finger",
  2: "Right index finger",
  3: "Left middle finger",
  4: "Right middle finger",
  5: "Left ring finger",
  6: "Right ring finger",
  7: "Left baby finger",
  8: "Right baby finger",
  9: "Left thumb",
  10: "Right thumb",
};
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
  bool consentPhoto = false;
  bool finger1 = false;
  bool finger2 = false;
  bool finger3 = false;
  bool finger4 = false;
  bool finger5 = false;
  bool finger6 = false;
  bool finger7 = false;
  bool finger8 = false;
  bool finger9 = false;
  bool finger10 = false;

  List<int> iso = [];
  List<String> fingerprints = [];
  String faceImage = "";
  String consentImage = "";
  late TextEditingController uidController;
  late TextEditingController fatherNameController;
  late TextEditingController regionController;
  late TextEditingController spouseNameController;
  late TextEditingController genderController;
  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController doi1Controller;
  late TextEditingController doi2Controller;

  File? imageFile;
  File? consentFile;
  late Animation<double> _animation;
  late AnimationController _animationController;
  bool error = false;
  bool loading = false;
  //= File("assets/images/userDummyPhoto.png");
  @override
  void initState() {
    rescan = false;
    imageFile = null;
    consentFile = null;
    faceImage = "";
    consentImage = "";
    faceLoading = false;
    fingerScanned = 0;
    photoTaken = false;
    index = satsangiListData.index;
    dialogLoading = false;
    consentPhoto = false;
    consentLoading = false;
    iso = [];
    fingerprints = [];
    regionController = TextEditingController(
        text: satsangiListData.satsangiList[satsangiListData.index].region);
    genderController = TextEditingController(
        text: satsangiListData.satsangiList[satsangiListData.index].gender);
    spouseNameController = TextEditingController(
        text: satsangiListData.satsangiList[satsangiListData.index].spouseName);
    fatherNameController = TextEditingController(
        text: satsangiListData.satsangiList[satsangiListData.index].fatherName);
    uidController =
        TextEditingController(text: satsangiListData.satsangiList[index].uid);

    nameController =
        TextEditingController(text: satsangiListData.satsangiList[index].name);
    dobController =
        TextEditingController(text: satsangiListData.satsangiList[index].dob);

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
    try {
      final ImagePicker _picker = ImagePicker();
      Navigator.pop(context);

      // Capture a photo
      var image = await _picker.getImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
      Uint8List imagebytes = await image!.readAsBytes(); //convert to bytes
      faceImage = base64.encode(imagebytes); //convert bytes to base64 string
      //VxToast.show(context, msg: "please wait while we check the image");
      // Navigator.pop(context);
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) => _buildPopUpWait(context));

      setState(() {
        faceLoading = true;
        VxToast.show(context,
            msg: "please wait unitl we process the image", showTime: 2000);
      });
      //bool faceCorrect = false; //optional
      bool faceCorrect = await PostApi().checkFace(
          "data:image/jpeg;base64,$faceImage",
          context,
          satsangiListData.satsangiList[index].uid);
      setState(() {
        // faceCorrect = true; // optional
        faceLoading = false;
      });
      //  faceapi not working
      print(faceCorrect);
      if (!faceCorrect) {
        VxToast.show(context, msg: "please capture image again");
      }
      if (image != null && faceCorrect) {
        imageFile = File(image.path);
        photoTaken = true;

        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupImage(context));
        setState(() {});
      }
    } catch (e) {}
  }

  getConsent() async {
    final ImagePicker _picker = ImagePicker();
    Navigator.pop(context);

    // Capture a photo
    var image = await _picker.getImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (image != null) {
      Uint8List imagebytes = await image!.readAsBytes();
      consentImage = base64.encode(imagebytes); //convert bytes to base64 string
      //VxToast.show(context, msg: "please wait while we check the image");
      // Navigator.pop(context);
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) => _buildPopUpWait(context));

      setState(() {
        // faceCorrect = true; // optional
        consentLoading = false;
      });
      //  faceapi not working

      if (image != null) {
        consentFile = File(image.path);
        consentPhoto = true;

        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupConsent(context));
        setState(() {});
      }
    }
  }

  //getImage() async {
  //  testImage = await PostApi().getTestImage();
  //   setState(() {});
  // }

  initialiseReader() async {
    try {
      await MethodChannels().init();
      // ignore: empty_catches
    } on PlatformException catch (e) {
      VxToast.show(context, msg: "error connecting the device");
    }
  }

  startReadingFirst() async {
    //initialiseReader();
    setState(() {
      loading = true;
    });

    // fingerTemp1 = await MethodChannels().startAutoCapture(1000, true);
  }

  startReadingSecond() async {
    //initialiseReader();
    setState(() {
      loading = true;
    });

    // fingerTemp2 = await MethodChannels().startAutoCapture(1000, true);
    // if (fingerTemp1 != null) {
    //   setState(() {
    //     fingerData1 = fingerTemp1.fingerImage;
    //     finger1 = true;
    //   });
    // } else {
    //   VxToast.show(context, msg: "Please place the finger on the scanner");
    //   setState(() {
    //     fingerData1 = Uint8List(0);
    //     finger1 = false;
    //   });
    // }
  }

  getFingerFinal(
    int fingerIso,
  ) async {
    setState(() {
      dialogLoading = true;
    });
    int match = 0;
    try {
      match = await MethodChannels()
          .matchISO(fingerTemp1.iSOTemplate, fingerTemp2.iSOTemplate);
    } catch (e) {}
    setState(() {
      dialogLoading = false;
    });
    Navigator.pop(context);

    if (match > 600) {
      Navigator.pop(context);
      print(fingerIso);
      if (fingerIso == 1) {
        if (!finger1) {
          fingerScanned++;
        }
        finger1 = true;
        if (!rescan) {
          iso.add(7);
          fingerprints.add(base64.encode(fingerData1));
        } else {
          int index = checkForExistingIso(7);
          iso[index] = 7;
          fingerprints[index] = base64.encode(fingerData1);
        }
        print(iso);
        rescan = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger1(context));
      } else if (fingerIso == 2) {
        if (!finger2) {
          fingerScanned++;
        }
        finger2 = true;
        if (!rescan) {
          iso.add(2);
          fingerprints.add(base64.encode(fingerData2));
        } else {
          int index = checkForExistingIso(2);
          iso[index] = 2;
          fingerprints[index] = base64.encode(fingerData2);
        }
        print(iso);
        rescan = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger2(context));
      } else if (fingerIso == 3) {
        if (!finger3) {
          fingerScanned++;
        }
        finger3 = true;
        if (!rescan) {
          iso.add(8);
          fingerprints.add(base64.encode(fingerData3));
        } else {
          int index = checkForExistingIso(8);
          iso[index] = 8;
          fingerprints[index] = base64.encode(fingerData3);
        }
        print(iso);
        rescan = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger3(context));
      } else if (fingerIso == 4) {
        if (!finger4) {
          fingerScanned++;
        }
        finger4 = true;

        if (!rescan) {
          iso.add(3);

          fingerprints.add(base64.encode(fingerData4));
        } else {
          int index = checkForExistingIso(3);
          iso[index] = 3;
          fingerprints[index] = base64.encode(fingerData4);
        }
        print(iso);
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger4(context));
      } else if (fingerIso == 5) {
        if (!finger5) {
          fingerScanned++;
        }
        finger5 = true;

        if (!rescan) {
          iso.add(9);
          fingerprints.add(base64.encode(fingerData5));
        } else {
          int index = checkForExistingIso(9);
          iso[index] = 9;
          fingerprints[index] = base64.encode(fingerData5);
        }
        print(iso);
        rescan = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger5(context));
      } else if (fingerIso == 6) {
        if (!finger6) {
          fingerScanned++;
        }
        finger6 = true;
        if (!rescan) {
          iso.add(4);
          fingerprints.add(base64.encode(fingerData6));
        } else {
          int index = checkForExistingIso(4);
          iso[index] = 4;
          fingerprints[index] = base64.encode(fingerData6);
        }
        print(iso);
        rescan = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger6(context));
      } else if (fingerIso == 7) {
        if (!finger7) {
          fingerScanned++;
        }
        finger7 = true;
        if (!rescan) {
          iso.add(10);
          fingerprints.add(base64.encode(fingerData7));
        } else {
          int index = checkForExistingIso(10);
          iso[index] = 10;
          fingerprints[index] = base64.encode(fingerData7);
        }
        print(iso);
        rescan = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger7(context));
      } else if (fingerIso == 8) {
        if (!finger8) {
          fingerScanned++;
        }
        finger8 = true;
        if (!rescan) {
          iso.add(5);
          fingerprints.add(base64.encode(fingerData8));
        } else {
          int index = checkForExistingIso(5);
          iso[index] = 5;
          fingerprints[index] = base64.encode(fingerData8);
        }
        print(iso);
        rescan = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger8(context));
      } else if (fingerIso == 9) {
        if (!finger9) {
          fingerScanned++;
        }
        finger9 = true;
        if (!rescan) {
          iso.add(6);
          fingerprints.add(base64.encode(fingerData9));
        } else {
          int index = checkForExistingIso(6);
          iso[index] = 6;
          fingerprints[index] = base64.encode(fingerData9);
        }
        print(iso);
        rescan = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger9(context));
      } else if (fingerIso == 10) {
        if (!finger10) {
          fingerScanned++;
        }
        finger10 = true;
        if (!rescan) {
          iso.add(1);
          fingerprints.add(base64.encode(fingerData10));
        } else {
          int index = checkForExistingIso(1);
          iso[index] = 1;
          fingerprints[index] = base64.encode(fingerData10);
        }
        print(iso);
        rescan = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger10(context));
      }
    } else {
      VxToast.show(context, msg: "finger prints not matched");
      Navigator.pop(context);

      if (fingerIso == 1) {
        finger1 = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger1(context));
      } else if (fingerIso == 2) {
        finger2 = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger2(context));
      } else if (fingerIso == 3) {
        finger3 = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger3(context));
      } else if (fingerIso == 4) {
        finger4 = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger4(context));
      } else if (fingerIso == 5 && fingerScanned < 4) {
        finger5 = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger5(context));
      } else if (fingerIso == 6 && fingerScanned < 4) {
        finger6 = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger6(context));
      } else if (fingerIso == 7 && fingerScanned < 4) {
        finger7 = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger7(context));
      } else if (fingerIso == 8 && fingerScanned < 4) {
        finger8 = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger8(context));
      } else if (fingerIso == 9 && fingerScanned < 4) {
        finger9 = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger9(context));
      } else if (fingerIso == 10 && fingerScanned < 4) {
        finger10 = false;
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger10(context));
      }
    }
    setState(() {});
  }

  int checkForExistingIso(int fingerIso) {
    int index = iso.length - 1;
    for (int i = 0; i < iso.length; i++) {
      if (iso[i] == fingerIso) {
        index = i;
        break;
      }
    }
    return index;
  }

  getFingerprint(int fingerIso, int index) async {
    Uint8List result = Uint8List(0);
    int code = 0;
    print(code);
    print(index);
    try {
      if (index == 1) {
        fingerTemp1 =
            await MethodChannels().startAutoCapture(context, 1000, true);
        if (fingerTemp1 != null) {
          code = 1;
          result = fingerTemp1.fingerImage;
        } else {
          code = 0;
        }
      } else if (index == 2) {
        fingerTemp2 =
            await MethodChannels().startAutoCapture(context, 1000, true);
        if (fingerTemp2 != null) {
          code = 1;
          result = fingerTemp1.nfiq > fingerTemp2.nfiq
              ? fingerTemp1.fingerImage
              : fingerTemp2.fingerImage;
        } else {
          code = 0;
        }
      }

      if (result.isNotEmpty) {
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
        } else if (fingerIso == 7) {
          fingerData7 = result;
        } else if (fingerIso == 8) {
          fingerData8 = result;
        } else if (fingerIso == 9) {
          fingerData9 = result;
        } else if (fingerIso == 10) {
          fingerData10 = result;
        }
        //int code = convertUint8ListToString(result);
        print(code);
        print(index);
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
            } else if (fingerIso == 7) {
              finger7 = false;
            } else if (fingerIso == 8) {
              finger8 = false;
            } else if (fingerIso == 9) {
              finger9 = false;
            } else if (fingerIso == 10) {
              finger10 = false;
            }
          });

          if (index == 1) {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildPopupretakeFingerprint1(context, fingerIso));
          } else if (index == 2) {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildPopupretakeFingerprint2(context, fingerIso));
          }
        }

        if (code == 1) {
          setState(() {
            if (index == 1) {
              // print("second");
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupScanSecondTime(context, fingerIso));
            } else if (index == 2) {
              print("check");
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupGetMatchFingerPrint(context, fingerIso));
            }
            setState(() {});
            loading = false;
          });
        }
      }
    } on PlatformException catch (e) {
      print("exception $e");
    }
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
    } else if (String.fromCharCodes(uint8list) == "bad image") {
      Navigator.pop(context);
      VxToast.show(context, msg: "image quality not proper please scan again");
      return 2;
    } else {
      return 1;
    }
  }

  resetData() {
    setState(() {
      imageFile = null;
      consentFile = null;
      photoTaken = false;
      consentPhoto = false;
      iso.clear();
      fingerprints.clear();
      finger1 = finger2 = finger3 = finger4 = finger5 = finger6 = false;
      fingerScanned = 0;
    });
  }

  updateData() async {
    setState(() {
      faceLoading = true;
    });
    await PostApi().updateSatsangiBiometric(
        satsangiListData.satsangiList[satsangiListData.index].uid,
        iso[0],
        iso[1],
        iso[2],
        iso[3],
        fingerprints[0],
        fingerprints[1],
        fingerprints[2],
        fingerprints[3],
        faceImage,
        consentImage,
        context);

    setState(() {
      faceLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (faceLoading)
          return false;
        else
          return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: "Registration".text.make(),
          actions: [
            if (fingerScanned >= 4)
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
                      faceImage != "" &&
                      fingerScanned == 4) {
                    if (!faceLoading) {
                      FirebaseLog().logError("iso", iso.toString());
                      FirebaseLog().logError(
                          "fingerprints", fingerprints.length.toString());
                      updateData();
                    } else {
                      VxToast.show(context, msg: "Please wait (processing)");
                    }
                    //VxToast.show(context, msg: "details updated");
                  } else {
                    FirebaseLog().logError("iso", iso.toString());
                    FirebaseLog().logError(
                        "fingerprints", fingerprints.length.toString());
                    VxToast.show(context,
                        msg: "error please try after resetting");
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
            if (faceLoading) CircularProgressIndicator(),
            5.heightBox,
            if (consentFile != null) "Consent".text.bold.size(15).white.make(),
            if (consentFile != null)
              Card(
                  color: Colors.orange.shade200,
                  child: Column(children: [
                    5.heightBox,
                    Image.file(
                      consentFile!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ).pOnly(bottom: 10),
                  ])),
            5.heightBox,
            if (imageFile != null) "Face Image".text.bold.size(15).white.make(),
            if (imageFile != null)
              Card(
                  color: Colors.orange.shade200,
                  child: Column(children: [
                    5.heightBox,
                    Image.file(
                      imageFile!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ).pOnly(bottom: 10),
                  ])),
            5.heightBox,
            if (imageFile == null)
              CircleAvatar(
                radius: 100,
                child: Image.asset("assets/addPhoto.png"),
              ),
            5.heightBox,
            if (finger1 || finger2) "Index finger prints".text.make(),
            5.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (finger1)
                  Card(
                    color: Colors.orange.shade200,
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
                if (finger2)
                  Card(
                    color: Colors.orange.shade200,
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
              ],
            ),
            5.heightBox,
            if (finger3 || finger4) "Middle finger prints".text.make(),
            5.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (finger3)
                  Card(
                    color: Colors.orange.shade200,
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
                if (finger4)
                  Card(
                    color: Colors.orange.shade200,
                    child: Column(
                      children: [
                        "right middle finger".text.black.make(),
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
                    color: Colors.orange.shade200,
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
                    color: Colors.orange.shade200,
                    child: Column(
                      children: [
                        "right ring finger".text.black.make(),
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
            if (finger7 || finger8) "Little finger prints".text.make(),
            5.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (finger7)
                  Card(
                    color: Colors.orange.shade200,
                    child: Column(
                      children: [
                        "left baby finger".text.black.make(),
                        5.heightBox,
                        Image.memory(
                          fingerData7,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ).p(5),
                  ),
                if (finger8)
                  Card(
                    color: Colors.orange.shade200,
                    child: Column(
                      children: [
                        "Right baby finger".text.black.make(),
                        5.heightBox,
                        Image.memory(
                          fingerData8,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ).p(5),
                  ),
              ],
            ),
            if (finger9 || finger10) "thumb prints".text.make(),
            5.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (finger9)
                  Card(
                    color: Colors.orange.shade200,
                    child: Column(
                      children: [
                        "left thumb finger".text.black.make(),
                        5.heightBox,
                        Image.memory(
                          fingerData9,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ).p(5),
                  ),
                if (finger10)
                  Card(
                    color: Colors.orange.shade200,
                    child: Column(
                      children: [
                        "Right thumb finger".text.black.make(),
                        5.heightBox,
                        Image.memory(
                          fingerData10,
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
              style: TextStyle(color: Colors.grey),
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
              style: TextStyle(color: Colors.grey),
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
              style: TextStyle(color: Colors.grey),
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
              style: TextStyle(color: Colors.grey),
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
              style: TextStyle(color: Colors.grey),
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
              style: TextStyle(color: Colors.grey),
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
              style: TextStyle(color: Colors.grey),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (fingerScanned >= 4)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      primary: Colors.orange,
                    ),
                    onPressed: () {
                      //VxToast.show(context, msg: "Details Updated");
                      if (!faceLoading) resetData();
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
                    if (!consentLoading) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupConsent(context));
                    }
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (consentFile != null)
                            ? const Text('Add Biometric',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15))
                            : const Text('Add consent',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                        5.widthBox,
                        Icon(Icons.fingerprint, color: Colors.green),
                      ]),
                ).p(5),
              ],
            ),
            20.heightBox,
          ]).p(10),
        ),
      ),
    );
  }

  Widget _buildPopupretakeFingerprint2(BuildContext context, int fingerIso) {
    return AlertDialog(
      titleTextStyle: TextStyle(fontSize: 18),
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("please place the finger before starting scan").centered(),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Colors.orange,
          ),
          onPressed: () {
            Navigator.pop(context);
            //print("re read iso $fingerIso");
            startReadingSecond();
            getFingerprint(fingerIso, 2);
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

  Widget _buildPopupretakeFingerprint1(BuildContext context, int fingerIso) {
    return AlertDialog(
      titleTextStyle: TextStyle(fontSize: 18),
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Please place the finger before starting scan").centered(),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Colors.orange,
          ),
          onPressed: () {
            Navigator.pop(context);
            //print("re read iso $fingerIso");
            startReadingFirst();
            getFingerprint(fingerIso, 1);
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
      titleTextStyle: TextStyle(fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text("Left index finger").centered(),
      actions: <Widget>[
        Center(
          child: Container(
            width: 150,
            height: 150,
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
              if (finger1) {
                fingerScanned--;
                rescan = true;
              }
              finger1 = false;
              if (fingerScanned >= 4) {
                VxToast.show(context,
                    msg: "you cannot scan more than 4 fingerprints");
              } else {
                startReadingFirst();
                getFingerprint(1, 1);
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupFingerprint1(context, 1));

              }
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
        if (!finger1)
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ]),
            ),
          ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              if (finger1) {
                Navigator.pop(context);

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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger1) Icon(Icons.check, color: Colors.green),
                ]),
          ),
        ),
        5.heightBox,
      ],
    );
  }

  Widget _buildPopupFinger2(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      titleTextStyle: TextStyle(fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Right index finger").centered(),
      actions: <Widget>[
        Center(
          child: Container(
            width: 150,
            height: 150,
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
              if (finger2) {
                fingerScanned--;
                rescan = true;
              }
              finger2 = false;
              if (fingerScanned >= 4) {
                VxToast.show(context,
                    msg: "you cannot scan more than 4 fingerprints");
              } else {
                startReadingFirst();
                getFingerprint(2, 1);
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupFingerprint1(context, 2));
              }
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
        if (!finger2)
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ]),
            ),
          ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              if (finger2) {
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger2) Icon(Icons.check, color: Colors.green),
                ]),
          ),
        ),
        5.heightBox,
      ],
    );
  }

  Widget _buildPopupFinger3(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      titleTextStyle: TextStyle(fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Left middle finger").centered(),
      actions: <Widget>[
        Center(
          child: Container(
            width: 150,
            height: 150,
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
              if (finger3) {
                fingerScanned--;
                rescan = true;
              }
              finger3 = false;
              if (fingerScanned >= 4) {
                VxToast.show(context,
                    msg: "you cannot scan more than 4 fingerprints");
              } else {
                startReadingFirst();
                getFingerprint(3, 1);
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupFingerprint1(context, 3));
              }
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
        if (!finger3)
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ]),
            ),
          ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              if (finger3) {
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger3) Icon(Icons.check, color: Colors.green),
                ]),
          ),
        ),
        5.heightBox,
      ],
    );
  }

  Widget _buildPopupFinger4(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      titleTextStyle: TextStyle(fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Right middle finger").centered(),
      actions: <Widget>[
        Center(
          child: Container(
            width: 150,
            height: 150,
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
              if (finger4) {
                fingerScanned--;
                rescan = true;
              }
              finger4 = false;
              if (fingerScanned >= 4) {
                VxToast.show(context,
                    msg: "you cannot scan more than 4 fingerprints");
              } else {
                startReadingFirst();
                getFingerprint(4, 1);
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupFingerprint1(context, 4));
              }
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
        if (!finger4)
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ]),
            ),
          ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              print(fingerScanned);
              if (finger4 && fingerScanned < 4) {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupFinger5(context));
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger4) Icon(Icons.check, color: Colors.green),
                ]),
          ),
        ),
        5.heightBox,
      ],
    );
  }

  Widget _buildPopupFinger5(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Left ring finger").centered(),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: <Widget>[
        Center(
          child: Container(
            width: 150,
            height: 150,
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
              if (finger5) {
                fingerScanned--;
                rescan = true;
              }
              finger5 = false;
              if (fingerScanned >= 4) {
                VxToast.show(context,
                    msg: "you cannot scan more than 4 fingerprints");
              } else {
                startReadingFirst();
                getFingerprint(5, 1);
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupFingerprint1(context, 5));
              }
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
        if (!finger5)
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
                        _buildPopupFinger6(context));
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
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              print(fingerScanned);
              if (finger5 && fingerScanned < 4) {
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger5) Icon(Icons.check, color: Colors.green),
                ]),
          ),
        ),
        5.heightBox,
      ],
    );
  }

  Widget _buildPopupFinger6(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Right ring finger").centered(),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: <Widget>[
        Center(
          child: Container(
            width: 150,
            height: 150,
            child: Image.asset(
              "assets/RR.png",
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
              if (finger6) {
                fingerScanned--;
                rescan = true;
              }
              finger6 = false;
              if (fingerScanned >= 4) {
                VxToast.show(context,
                    msg: "you cannot scan more than 4 fingerprints");
              } else {
                startReadingFirst();
                getFingerprint(6, 1);
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupFingerprint1(context, 6));
              }
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
        if (!finger6)
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
                        _buildPopupFinger7(context));
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
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              if (finger6 && fingerScanned < 4) {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupFinger7(context));
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger6) Icon(Icons.check, color: Colors.green),
                ]),
          ),
        ),
        5.heightBox,
      ],
    );
  }

  Widget _buildPopupFinger7(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Left baby finger").centered(),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: <Widget>[
        Center(
          child: Container(
            width: 150,
            height: 150,
            child: Image.asset(
              "assets/LB.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        5.heightBox,
        if (finger7)
          Center(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.memory(
                    fingerData7,
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
              if (finger7) {
                fingerScanned--;
                rescan = true;
              }
              finger7 = false;
              if (fingerScanned >= 4) {
                VxToast.show(context,
                    msg: "you cannot scan more than 4 fingerprints");
              } else {
                startReadingFirst();
                getFingerprint(7, 1);
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupFingerprint1(context, 7));
              }
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  finger7
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
        if (!finger7)
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
                        _buildPopupFinger8(context));
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
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              if (finger7 && fingerScanned < 4) {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupFinger8(context));
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger7) Icon(Icons.check, color: Colors.green),
                ]),
          ),
        ),
        5.heightBox,
      ],
    );
  }

  Widget _buildPopupFinger8(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Right baby finger").centered(),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: <Widget>[
        Center(
          child: Container(
            width: 150,
            height: 150,
            child: Image.asset(
              "assets/RB.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        5.heightBox,
        if (finger8)
          Center(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.memory(
                    fingerData8,
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
              if (finger8) {
                fingerScanned--;
                rescan = true;
              }
              finger8 = false;
              if (fingerScanned >= 4) {
                VxToast.show(context,
                    msg: "you cannot scan more than 4 fingerprints");
              } else {
                startReadingFirst();
                getFingerprint(8, 1);
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupFingerprint1(context, 8));
              }
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  finger8
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
        if (!finger8)
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
                        _buildPopupFinger9(context));
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
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              if (finger8 && fingerScanned < 4) {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupFinger9(context));
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger8) Icon(Icons.check, color: Colors.green),
                ]),
          ),
        ),
        5.heightBox,
      ],
    );
  }

  Widget _buildPopupFinger9(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Left thumb finger").centered(),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: <Widget>[
        Center(
          child: Container(
            width: 150,
            height: 150,
            child: Image.asset(
              "assets/LT.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        5.heightBox,
        if (finger9)
          Center(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.memory(
                    fingerData9,
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
              if (finger9) {
                fingerScanned--;
                rescan = true;
              }
              finger9 = false;
              if (fingerScanned >= 4) {
                VxToast.show(context,
                    msg: "you cannot scan more than 4 fingerprints");
              } else {
                startReadingFirst();
                getFingerprint(9, 1);
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupFingerprint1(context, 9));
              }
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  finger9
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
        if (!finger9)
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
                        _buildPopupFinger10(context));
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
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              if (finger9 && fingerScanned < 4) {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupFinger10(context));
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger9) Icon(Icons.check, color: Colors.green),
                ]),
          ),
        ),
        5.heightBox,
      ],
    );
  }

  Widget _buildPopupFinger10(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Right thumb finger").centered(),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: <Widget>[
        Center(
          child: Container(
            width: 150,
            height: 150,
            child: Image.asset(
              "assets/RT.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        5.heightBox,
        if (finger10)
          Center(
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.memory(
                    fingerData10,
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
              if (finger10) {
                fingerScanned--;
                rescan = true;
              }
              finger10 = false;
              if (fingerScanned >= 4) {
                VxToast.show(context,
                    msg: "you cannot scan more than 4 fingerprints");
              } else {
                startReadingFirst();
                getFingerprint(10, 1);
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupFingerprint1(context, 10));
              }
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  finger10
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
        if (!finger10)
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.orange,
              ),
              onPressed: () {
                Navigator.pop(context);
                VxToast.show(context, msg: "finger scans are neccessary");
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
          ),
        5.heightBox,
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              if (finger10 && fingerScanned < 4) {
                Navigator.pop(context);
              } else if (fingerScanned >= 4) {
                Navigator.pop(context);
              } else if (!finger10 && fingerScanned < 4) {
                Navigator.pop(context);
                VxToast.show(context, msg: "finger scans are neccessary");
              }
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (finger10) Icon(Icons.check, color: Colors.green),
                ]),
          ),
        ),
        5.heightBox,
      ],
    );
  }

  // Widget _buildPopupFingerprint1(BuildContext context, int fingerIso) {
  //   return AlertDialog(
  //     backgroundColor: Colors.blueGrey,
  //     title: Text("Click to Start Scan").centered(),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     titleTextStyle: TextStyle(fontSize: 18),
  //     actions: [
  //       5.heightBox,
  //       Text("Place the finger on the scanner until the red light turns off")
  //           .centered()
  //           .p(5),
  //       5.heightBox,
  //       Center(
  //         child: InkWell(
  //           onTap: () {
  //             getFingerprint(fingerIso, 1);
  //           },
  //           child: Icon(
  //             Icons.arrow_circle_right,
  //             size: 60,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ),
  //       // ],
  //     ],
  //     // scrollable: true,
  //     // backgroundColor: Colors.blueGrey,
  //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     // //  title: "Continue".text.make().centered(),
  //     // titleTextStyle: TextStyle(fontSize: 18),
  //     //
  //   );
  // }

  // Widget _buildPopupFingerprint2(BuildContext context, int fingerIso) {
  //   return AlertDialog(
  //     backgroundColor: Colors.blueGrey,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     title: Text("Click to Start Scan").centered(),
  //     titleTextStyle: TextStyle(fontSize: 18),
  //     actions: [
  //       5.heightBox,
  //       Text("Place the finger on the scanner until the red light turns off")
  //           .centered()
  //           .p(5),
  //       5.heightBox,
  //       Center(
  //         child: InkWell(
  //           onTap: () {
  //             getFingerprint(fingerIso, 2);
  //           },
  //           child: Icon(
  //             Icons.arrow_circle_right,
  //             size: 60,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildPopUpWait(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Please wait while we process the photo"),
      titleTextStyle: TextStyle(fontSize: 18),
    );
  }

  Widget _buildPopupGetMatchFingerPrint(BuildContext context, int fingerIso) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.orange,
            ),
            onPressed: () {
              if (!dialogLoading) {
                Navigator.pop(context);
                getFingerFinal(fingerIso);
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Show Fingerprint',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupScanSecondTime(BuildContext context, int fingerIso) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Please take second scan of \n-> ${fingerIsoMap[fingerIso]}"),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: [
        Text("Remove the finger and place it again"),
        15.heightBox,
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Colors.orange,
          ),
          onPressed: () {
            startReadingSecond();

            getFingerprint(fingerIso, 2);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Start scan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupImage(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (faceLoading)
          return false;
        else
          return true;
      },
      child: AlertDialog(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: (imageFile != null)
            ? Text("Face image").centered()
            : Text("Please capture face image"),
        titleTextStyle: TextStyle(fontSize: 18),
        actions: <Widget>[
          if (imageFile != null)
            Center(
              child: Container(
                height: 300,
                width: 250,
                child: Card(
                    color: Colors.orange.shade200,
                    child: Column(children: [
                      5.heightBox,
                      Image.file(
                        imageFile!,
                        width: 250,
                        height: 250,
                        fit: BoxFit.contain,
                      ).p(10),
                    ])),
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
                    child: (photoTaken && !faceLoading)
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
                if (photoTaken && !faceLoading)
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
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Next",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupConsent(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: consentPhoto
          ? Text("Consent Form").centered()
          : Text("Please take a photo of the consent form"),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: <Widget>[
        if (consentFile != null && consentPhoto)
          Center(
            child: Container(
              width: 300,
              height: 250,
              child: Card(
                  color: Colors.orange.shade200,
                  child: Column(children: [
                    5.heightBox,
                    Image.file(
                      consentFile!,
                      width: 300,
                      height: 200,
                      fit: BoxFit.contain,
                    ).p(10),
                  ])),
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
                  getConsent();
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: (consentPhoto && !consentLoading)
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
              if (consentPhoto && !consentLoading)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (!consentLoading) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupImage(context));
                    }
                  },
                  child: const Padding(
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
