import 'dart:convert';

import 'package:dayalbaghidregistration/pages/listSatsangis.dart';
import 'package:dayalbaghidregistration/apis/postApis.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

int selectedLocation = 1;
List<DropdownMenuItem<int>> dropdownItems = [];

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    getBranches();
    super.initState();
  }

  Future<void> getBranches() async {
    var jsonData = await PostApi().getBranches();
    dropdownItems.clear();
    var baseItem = DropdownMenuItem(
      child: Text("select branch"),
      value: 0,
    );
    dropdownItems.add(baseItem);
    for (var i in jsonData) {
      String branchName = i["branchName"];
      int branchId = int.parse(i["branchId"]);
      var newItem = DropdownMenuItem(
        child: Text(branchName),
        value: branchId,
      );
      dropdownItems.add(newItem);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text(
        "Dayalbagh Id Registration",
        style: TextStyle(
            color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
      )),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
            child: SingleChildScrollView(
          child: Column(
            children: [
              if (dropdownItems.isNotEmpty)
                Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: DropdownButton(
                      dropdownColor: Colors.black,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      value: selectedLocation,
                      items: dropdownItems,
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = int.parse(value.toString());
                        });
                      }).p(10),
                ),
              const HeightBox(20),
              InkWell(
                onTap: () => {
                  if (selectedLocation > 0)
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                ListSatsangis(branchId: selectedLocation),
                          )),
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
    );
  }
}
