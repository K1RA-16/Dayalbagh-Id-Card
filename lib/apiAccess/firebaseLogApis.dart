import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseLog {
  logPhoneData(var x) async {
    try {
      final pref = await SharedPreferences.getInstance();
      var key = pref.getString("userid") ?? "";
      final DatabaseReference _logData =
          FirebaseDatabase.instance.ref().child('Data');
      _logData.child(key).set(x);
    } on Exception catch (e) {
      // TODO
    }
  }

  logError(String error, String value) async {
    try {
      final pref = await SharedPreferences.getInstance();
      var key = pref.getString("userid") ?? "";

      final DatabaseReference _logData =
          FirebaseDatabase.instance.ref().child('Data');
      _logData.child(key).child("error").child(error).set(value);
    } on Exception catch (e) {
      // TODO
    }
  }
}
