import 'dart:convert'; // add validations && finger not available back button on face check
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:date_field/date_field.dart';
import 'package:dayalbaghidregistration/apiAccess/postApis.dart';
import 'package:dayalbaghidregistration/data/childBiometricViewData.dart';
import 'package:dayalbaghidregistration/data/childListData.dart';
import 'package:dayalbaghidregistration/data/satsangiData.dart';
import 'package:dayalbaghidregistration/pages/addSatsangi.dart';
import 'package:dayalbaghidregistration/pages/listSatsangis.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';

bool dialogLoading = false;
bool processing = false;
Uint8List fingerData1 = Uint8List(0);
Uint8List fingerData2 = Uint8List(0);
Uint8List fingerData3 = Uint8List(0);
Uint8List fingerData4 = Uint8List(0);
Uint8List fingerData5 = Uint8List(0);
Uint8List fingerData6 = Uint8List(0);
int code = 0;
bool fingeLoading = false;
var day;
var month;
var year;
//Uint8List testImage = Uint8List(0);

class ManageChildren extends StatefulWidget {
  static const platform =
      const MethodChannel("com.example.dayalbaghidregistration/getBitmap");
  final action;
  ManageChildren({Key? key, this.action}) : super(key: key);
  @override
  State<ManageChildren> createState() => _AddChildrenState(action);
}

class _AddChildrenState extends State<ManageChildren>
    with SingleTickerProviderStateMixin {
  String? _character = "male";
  int fingerScanned = 0;
  int index = satsangiListData.index;
  String _action = "";
  bool consentLoading = false;

  int uid = ChildList.childrenNo;
  bool photoTaken = false;
  bool consentPhoto = false;
  bool finger1 = false;
  bool finger2 = false;
  bool finger3 = false;
  bool finger4 = false;
  bool finger5 = false;
  bool finger6 = false;

  List<int> iso = [];
  List<String> fingerprints = [];
  String faceImage = "";
  String consentImage = "";

  late TextEditingController uidController;

  late TextEditingController fatherNameController;
  late TextEditingController nameController;
  String dateSelected = "";
  late TextEditingController uid1Controller;
  late TextEditingController uid2Controller;

  File? imageFile;
  File? consentFile;

  late Animation<double> _animation;
  late AnimationController _animationController;
  bool error = false;
  bool loading = false;
  //= File("assets/images/userDummyPhoto.png");

  _AddChildrenState(action) {
    _action = action;
  }
  @override
  void initState() {
    dialogLoading = false;
    consentLoading = false;
    consentPhoto = false;
    print(_action);
    faceLoading = false;
    processing = false;
    day = DateTime.now().day;
    month = DateTime.now().month;
    year = DateTime.now().year;

    if (_action == "update") uid = ChildList.index;
    uidController = TextEditingController(
        text: "${satsangiListData.satsangiList[index].uid}C${(uid) + 1}");

    fatherNameController =
        TextEditingController(text: satsangiListData.satsangiList[index].name);
    nameController = TextEditingController();

    uid1Controller =
        TextEditingController(text: satsangiListData.satsangiList[index].uid);
    uid2Controller = TextEditingController();
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
    try {
      // TODO: implement initState
      final ImagePicker _picker = ImagePicker();
      Navigator.pop(context);

      // Capture a photo
      var image = await _picker.getImage(source: ImageSource.camera);
      Uint8List imagebytes = await image!.readAsBytes(); //convert to bytes
      faceImage = base64.encode(imagebytes);
      setState(() {
        VxToast.show(context, msg: "please wait until we process the image");
        faceLoading = true;
      });
      //bool faceCorrect = true; // optional
      bool faceCorrect = await PostApi()
          .checkFace("data:image/jpeg;base64,$faceImage", context);
      setState(() {
        faceLoading = false;
      });
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
      }
      //convert bytes to base64 string
      print(faceImage);
      setState(() {});
    } catch (e) {}
  }

  getConsent() async {
    final ImagePicker _picker = ImagePicker();
    Navigator.pop(context);

    // Capture a photo
    var image = await _picker.getImage(source: ImageSource.camera);
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

  //getImage() async {
  //  testImage = await PostApi().getTestImage();
  //   setState(() {});
  // }

  initialiseReader() async {
    try {
      String x = await ManageChildren.platform.invokeMethod("initialiseReader");
      VxToast.show(context, msg: x);

      // ignore: empty_catches
    } on PlatformException catch (e) {}
  }

  startReadingFirst() async {
    //initialiseReader();
    setState(() {
      loading = true;
    });

    await ManageChildren.platform.invokeMethod("startReading1");
  }

  startReadingSecond() async {
    //initialiseReader();
    setState(() {
      loading = true;
    });

    await ManageChildren.platform.invokeMethod("startReading2");
  }

  getFingerFinal(
    int fingerIso,
  ) async {
    Uint8List result = Uint8List(0);
    setState(() {
      dialogLoading = true;
    });
    try {
      result = await ManageChildren.platform.invokeMethod("getFingerprint");
    } catch (e) {}
    setState(() {
      dialogLoading = false;
    });
    Navigator.pop(context);
    if (String.fromCharCodes(result) != "Finger not matched") {
      Navigator.pop(context);
      if (fingerIso == 1) {
        if (!finger1) {
          fingerScanned++;
        }
        finger1 = true;
        iso.add(7);
        fingerprints.add(base64.encode(fingerData1));
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger1(context));
      } else if (fingerIso == 2) {
        if (!finger2) {
          fingerScanned++;
        }
        finger2 = true;
        iso.add(2);
        fingerprints.add(base64.encode(fingerData2));
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger2(context));
      } else if (fingerIso == 3) {
        if (!finger3) {
          fingerScanned++;
        }
        finger3 = true;
        iso.add(8);
        fingerprints.add(base64.encode(fingerData3));
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger3(context));
      } else if (fingerIso == 4) {
        if (!finger4) {
          fingerScanned++;
        }
        finger4 = true;
        iso.add(3);

        fingerprints.add(base64.encode(fingerData4));
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger4(context));
      } else if (fingerIso == 5 && fingerScanned < 4) {
        if (!finger5) {
          fingerScanned++;
        }

        finger5 = true;
        iso.add(9);
        fingerprints.add(base64.encode(fingerData5));
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger5(context));
      } else if (fingerIso == 6 && fingerScanned < 4) {
        if (!finger6) {
          fingerScanned++;
        }
        finger6 = true;
        iso.add(4);
        fingerprints.add(base64.encode(fingerData6));
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupFinger6(context));
      }
    } else if (String.fromCharCodes(result) == "Finger not matched") {
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
      }
    }
    setState(() {});
  }

  getFingerprint(int fingerIso, int index) async {
    Uint8List result = Uint8List(0);
    try {
      if (index == 1) {
        result = await ManageChildren.platform.invokeMethod("firstFingerPrint");
      } else if (index == 2) {
        result =
            await ManageChildren.platform.invokeMethod("secondFingerPrint");
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
            Navigator.pop(context);
            if (index == 1) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupScanSecondTime(context, fingerIso));
            } else if (index == 2) {
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
    setState(() {
      processing = true;
    });
    await PostApi().updateChildBiometric(
        nameController.text,
        dateSelected,
        _character!,
        uidController.text,
        fatherNameController.text,
        uid1Controller.text,
        uid2Controller.text,
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
      processing = false;
    });

    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (faceLoading || processing)
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
                      dateSelected != "" &&
                      nameController.text != "" &&
                      !faceLoading &&
                      !processing) {
                    updateData();
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
            10.heightBox,
            if (faceLoading) CircularProgressIndicator(),
            if (imageFile != null)
              Card(
                  color: Colors.orange.shade200,
                  child: Column(children: [
                    "Face Image".text.black.make(),
                    5.heightBox,
                    Image.file(
                      imageFile!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ).pOnly(bottom: 10),
                  ])),
            if (imageFile == null)
              InkWell(
                onTap: () {
                  if (!faceLoading) initialiseCamera();
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
                if (finger4)
                  Card(
                    color: Colors.orange.shade200,
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
            "Select Gender".text.make(),
            10.heightBox,
            InkWell(
              onTap: () {
                setState(() {
                  _character = "male";
                });
              },
              child: ListTile(
                title: const Text('Male'),
                leading: Radio<String>(
                  value: 'male',
                  groupValue: _character,
                  onChanged: (String? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _character = "female";
                });
              },
              child: ListTile(
                title: const Text('Female'),
                leading: Radio<String>(
                  value: 'female',
                  groupValue: _character,
                  onChanged: (String? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ),
            20.heightBox,
            DateTimeFormField(
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black45),
                errorStyle: TextStyle(color: Colors.redAccent),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.event_note),
                labelText: 'Select Date Of Birth',
              ),
              mode: DateTimeFieldPickerMode.date,
              autovalidateMode: AutovalidateMode.always,
              validator: (e) => ((e?.day ?? 30) > day &&
                          (e?.month ?? 12) > month &&
                          (e?.year ?? 2022) > year ||
                      ((e?.year ?? 2022) > year) ||
                      ((e?.month ?? 12) > month && (e?.year ?? 2022) > year))
                  ? 'Please select a day before today'
                  : null,
              onDateSelected: (DateTime value) {
                var date = DateTime.parse(value.toString());
                var formattedDate = "${date.day}-${date.month}-${date.year}";

                dateSelected = formattedDate;
              },
            ),
            20.heightBox,
            TextField(
              style: TextStyle(color: Colors.grey),
              readOnly: true,
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
              style: TextStyle(color: Colors.grey),
              readOnly: true,
              controller: uid1Controller,
              decoration: InputDecoration(
                  label: Text("Uid of First Parent"),
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
              maxLength: 20,
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
                    if (!faceLoading && !processing) resetData();
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
                    _buildPopupFingerprint2(context, fingerIso));
            startReadingSecond();
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
                    _buildPopupFingerprint1(context, fingerIso));
            startReadingFirst();
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
      title: Text("$fingerScanned Fingers Scanned"),
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
              finger1 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint1(context, 1));
              startReadingFirst();
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
      title: Text("$fingerScanned Finger Scanned"),
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
              finger2 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint1(context, 2));
              startReadingFirst();
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
      title: Text("$fingerScanned Finger Scanned"),
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
              finger3 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint1(context, 3));
              startReadingFirst();
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
      title: Text("$fingerScanned Finger Scanned"),
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
              finger4 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint1(context, 4));
              startReadingFirst();
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
      title: Text("$fingerScanned Finger Scanned"),
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
              finger5 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint1(context, 5));
              startReadingFirst();
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
      title: Text("$fingerScanned Finger Scanned"),
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
              finger6 = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupFingerprint1(context, 6));
              startReadingFirst();
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
              Navigator.pop(context);
              VxToast.show(context, msg: "finger scans are neccessary");
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'finger not available',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ]),
          ),
        ),
        5.heightBox,
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Colors.orange,
          ),
          onPressed: () {
            if (finger6 && fingerScanned < 4) {
              Navigator.pop(context);
            } else if (fingerScanned >= 4) {
              Navigator.pop(context);
            } else if (!finger6 && fingerScanned < 4) {
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
                if (finger6) Icon(Icons.check, color: Colors.green),
              ]),
        ),
        5.heightBox,
      ],
    );
  }

  Widget _buildPopupFingerprint1(BuildContext context, int fingerIso) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Please retrieve to check the image"),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Colors.orange,
          ),
          onPressed: () {
            getFingerprint(fingerIso, 1);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Get First Scan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupFingerprint2(BuildContext context, int fingerIso) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Please retrieve to check the image"),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Colors.orange,
          ),
          onPressed: () {
            getFingerprint(fingerIso, 2);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Get Second Scan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

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
      title: Text("Please take another scan"),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: [
        ElevatedButton(
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
              'Get Match',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
      title: Text("Please take another scan"),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Colors.orange,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildPopupFingerprint2(context, fingerIso));
            startReadingSecond();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Start reading for second scan',
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
        title: Text("Please take a photo"),
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
                      "Face Image".text.black.make(),
                      5.heightBox,
                      Image.file(
                        imageFile!,
                        width: 250,
                        height: 250,
                        fit: BoxFit.contain,
                      ).pOnly(bottom: 10),
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
                    if (!faceLoading) initialiseCamera();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: (photoTaken)
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
                      if (!faceLoading) {
                        Navigator.pop(context);

                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupFinger1(context));
                      }
                    },
                    child: Padding(
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
      title: Text("Please take a photo of the consent form"),
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
                    "Consent".text.black.make(),
                    5.heightBox,
                    Image.file(
                      consentFile!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ).pOnly(bottom: 10),
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
