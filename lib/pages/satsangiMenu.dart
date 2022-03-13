import 'package:dayalbaghidregistration/apiAccess/postApis.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SatsangiMenu extends StatefulWidget {
  @override
  State<SatsangiMenu> createState() => _SatsangiMenuState();
}

class _SatsangiMenuState extends State<SatsangiMenu> {
  bool progressIndicator = false;
  @override
  void initState() {
    // TODO: implement initState
    progressIndicator = false;
    super.initState();
  }

  getData() async {
    setState(() {
      progressIndicator = true;
    });
    await PostApi().getstsangiData(context);
    Navigator.pushNamed(context, "/viewSatsangi").then((value) => setState(() {
          progressIndicator = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text(
        "Dayalbagh Id Registration",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      )),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const HeightBox(20),
              InkWell(
                onTap: () => {Navigator.pushNamed(context, "/addSatsangi")},
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
                      Icon(Icons.add),
                      Center(
                        child: Text("Add Biometrics",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 19)),
                      ),
                    ],
                  ).p(20),
                ),
              ),
              const HeightBox(10),
              InkWell(
                onTap: () => {getData()},
                //     "/connectRfid")), //SystemSetting.goto(SettingTarget.BLUETOOTH)),
                child: Card(
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.blueGrey,
                    elevation: 8,
                    child: Column(
                      children: [
                        Center(
                          child: Text("View Biometrics",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19)),
                        ),
                      ],
                    ).p(20)),
              ),
              const HeightBox(10),
              InkWell(
                onTap: () => {PostApi().getChildList(context)},
                //     "/connectRfid")), //SystemSetting.goto(SettingTarget.BLUETOOTH)),
                child: Card(
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.blueGrey,
                    elevation: 8,
                    child: Column(
                      children: [
                        Center(
                          child: Text("Manage Children",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19)),
                        ),
                      ],
                    ).p(20)),
              ),
              const HeightBox(10),
              // InkWell(
              //   onTap: () => {},
              //   //     "/connectRfid")), //SystemSetting.goto(SettingTarget.BLUETOOTH)),
              //   child: Card(
              //       margin: const EdgeInsets.all(8.0),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15.0),
              //       ),
              //       color: Colors.blueGrey,
              //       elevation: 8,
              //       child: Column(
              //         children: [
              //           Center(
              //             child: Text("Manage Relatives",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold, fontSize: 19)),
              //           ),
              //         ],
              //       ).p(20)),
              // ),
              if (progressIndicator) CircularProgressIndicator().p(20),
            ],
          ),
        )),
      ),
    );
  }
}
