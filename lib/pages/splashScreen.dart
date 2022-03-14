import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import '../apiAccess/postApis.dart';
import '../utils/themes.dart';

// ignore: use_key_in_widget_constructors
class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  int x = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyThemes.grad2,
      body: ListView(
        children: [
          Image.asset("assets/splashScreen.png"),
          Container(
            alignment: Alignment.center,
            child: const Text(
              "Dayalbagh Biometric Registration",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          // Lottie.asset("assets/images/loading.json")
        ],
      ),
    );
  }

  startTime() async {
    await PostApi().getBranches(context, 0);
    //Navigator.pushNamed(context, page);
  }
}
