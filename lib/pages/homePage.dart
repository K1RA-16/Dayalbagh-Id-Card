import 'dart:convert';

import 'package:dayalbaghidregistration/apiAccess/firebaseLogApis.dart';
import 'package:dayalbaghidregistration/pages/listSatsangis.dart';
import 'package:dayalbaghidregistration/apiAccess/postApis.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

String selectedLocation = "select branch";
List<DropdownMenuItem<String>> dropdownItems = [];

class HomePage extends StatefulWidget {
  static const platform =
      const MethodChannel("com.example.dayalbaghidregistration/getBitmap");
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState

    getPhoneData();
    getBranches();
    super.initState();
  }

  getPhoneData() async {
    try {
      await Firebase.initializeApp();

      var x = await HomePage.platform.invokeMethod("getPhoneData");
      print("$x");
      FirebaseLog().logPhoneData(x);
      // ignor;e: empty_catches
    } on PlatformException catch (e) {}
  }

  Future<void> getBranches() async {
    int x = 1;
    var jsonData = await PostApi().getBranches(context, 1);
    dropdownItems.clear();
    var baseItem = DropdownMenuItem(
      child: Text("select branch"),
      value: "select branch",
    );
    dropdownItems.add(baseItem);
    for (var i in jsonData) {
      String branchName = i["branchName"];

      var newItem = DropdownMenuItem(
        child: Text(branchName),
        value: branchName,
      );

      dropdownItems.add(newItem);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Home",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (r) => false);
                },
                child: Icon(Icons.logout).pOnly(right: 20)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
              child: SingleChildScrollView(
            child: Column(
              children: [
                if (dropdownItems.isNotEmpty)
                  Card(
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          dropdownColor: Colors.blueGrey,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          value: selectedLocation,
                          items: dropdownItems,
                          onChanged: (value) {
                            setState(() {
                              selectedLocation = value.toString();
                            });
                          }).p(10),
                    ),
                  ).pOnly(left: 5, top: 20),
                const HeightBox(20),
                InkWell(
                  onTap: () => {
                    if (selectedLocation != "select branch")
                      {
                        print(selectedLocation),
                        PostApi().getSatsangisList(
                            selectedLocation, 0, 50, context, 1),
                      }
                    else
                      {VxToast.show(context, msg: "please select a branch")}
                  },
                  child: Card(
                    borderOnForeground: true,
                    elevation: 8,
                    margin: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.blueGrey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list),
                        10.widthBox,
                        Center(
                          child: Text("List Satsangis",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19)),
                        ),
                      ],
                    ).p(20),
                  ),
                ),
                const HeightBox(10),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
