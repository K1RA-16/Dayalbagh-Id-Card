import 'package:dayalbaghidregistration/apiAccess/postApis.dart';
import 'package:dayalbaghidregistration/pages/ViewChildren.dart';
import 'package:dayalbaghidregistration/pages/addSatsangi.dart';
import 'package:dayalbaghidregistration/pages/homePage.dart';
import 'package:dayalbaghidregistration/pages/listChildren.dart';
import 'package:dayalbaghidregistration/pages/listSatsangis.dart';
import 'package:dayalbaghidregistration/pages/splashScreen.dart';
import 'package:dayalbaghidregistration/pages/viewSatsangi.dart';

import 'package:dayalbaghidregistration/pages/login.dart';
import 'package:dayalbaghidregistration/pages/addChild.dart';
import 'package:dayalbaghidregistration/pages/satsangiMenu.dart';
import 'package:dayalbaghidregistration/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: MyThemes.lightTheme(context),
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => Splash(),
        "/home": (context) => HomePage(),
        "/addSatsangi": (context) => AddSatsangi(),
        "/login": (context) => LoginPage(),
        "/menu": (context) => SatsangiMenu(),
        "/children": (context) => ManageChildren(),
        "/childrenList": (context) => ListChildren(),
        "/viewSatsangi": (context) => ViewSatsangi(),
        "/viewChildren": (context) => ViewChildren(),
      },
    );
  }
}
