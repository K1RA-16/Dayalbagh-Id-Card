import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SatsangiMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text(
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
                        child: Text("Add User",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 19)),
                      ),
                    ],
                  ).p(20),
                ),
              ),
              const HeightBox(10),
              InkWell(
                onTap: () => {
                  Navigator.pushNamed(context, "/children")
                },
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
              InkWell(
                onTap: () {
                  //Navigator.pushNamed(context, "/listUpdate");
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.blueGrey,
                  child: Column(
                    children: [
                      Center(
                        child: Text("Request Transfer",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 19)),
                      ),
                    ],
                  ).p(20),
                ),
              ),
              const HeightBox(10),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/tagUpdate");
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.blueGrey,
                  child: Column(
                    children: [
                      Center(
                        child: Text("Delete User",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 19)),
                      ),
                    ],
                  ).p(20),
                ),
              ),
              const HeightBox(10),
              InkWell(
                onTap: () => {},
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.blueGrey,
                  child: Column(
                    children: [
                      Center(
                        child: Text("Search User",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 19)),
                      ),
                    ],
                  ).p(20),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
