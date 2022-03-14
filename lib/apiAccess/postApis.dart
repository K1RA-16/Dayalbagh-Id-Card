import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dayalbaghidregistration/apiAccess/firebaseLogApis.dart';
import 'package:dayalbaghidregistration/data/authData.dart';
import 'package:dayalbaghidregistration/data/SatsangiBiometricData.dart';
import 'package:dayalbaghidregistration/data/childJsonBiometricData.dart';
import 'package:dayalbaghidregistration/data/childBiometricViewData.dart';
import 'package:dayalbaghidregistration/data/childListData.dart';
import 'package:dayalbaghidregistration/data/paginationData.dart';
import 'package:dayalbaghidregistration/data/satsangiData.dart';
import 'package:dayalbaghidregistration/data/satsangiGetBiometricData.dart';
import 'package:dayalbaghidregistration/pages/listSatsangis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class PostApi {
  //logs in the user and saves the token to shared Pref...
  Future<void> login(
      String username, String password, BuildContext context) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      var jsonData = AuthData(username: username, password: password).toJson();
      http.Response response = await http.post(
          Uri.parse("https://api.dbidentity.in/api/login/authenticate"),
          body: jsonData,
          headers: {
            'Content-type': 'application/json',
          });
      var jsonReceived = jsonDecode(response.body);
      print(jsonReceived);
      if (jsonReceived["message"] == "Username or password is incorrect")
        VxToast.show(context, msg: "Username or password is incorrect");
      else {
        // Obtain shared preferences.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", jsonReceived["token"]);
        await prefs.setString("userid", username);
        Navigator.pushNamed(context, "/home");
      }
    }
  }

  //gets the branch list of that particular user
  Future<List<dynamic>> getBranches(BuildContext context) async {
    try {
      final pref = await SharedPreferences.getInstance();
      var token = pref.getString("token") ?? "";

      final response = await http.get(
          Uri.parse('https://api.dbidentity.in/api/branch/list'),
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      // // var jsonReceived = jsonDecode(response.body);
      print(response.body);
      return jsonDecode(response.body);
    } on Exception catch (e) {
      // TODO
      Map<String, dynamic> errLog = {"branches get": e};
      FirebaseLog().logError(errLog);
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      List<dynamic> m = [];
      return m;
    }
  }

  Future<void> getstsangiData(BuildContext context) async {
    try {
      final pref = await SharedPreferences.getInstance();
      var token = pref.getString("token") ?? "";
      Map<String, String> m = new Map();
      m["uid"] = satsangiListData.satsangiList[satsangiListData.index].uid;
      var json = jsonEncode(m);
      print(json);
      http.Response response = await http.post(
          Uri.parse("https://api.dbidentity.in/api/uidbio/getbiometric"),
          body: json,
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      var data = jsonDecode(response.body);
      print(data["uid"]);

      SatsangiGetBiometricMap.data = SatsangiGetBiometric(
        mobile: data["mobile"],
        name: data["name"],
        father_Or_Spouse_Name: data["father_Or_Spouse_Name"],
        dob: data["dob"],
        doi_First: data["doi_First"] ?? " ",
        doi_Second: data["doi_Second"] ?? " ",
        branchName: data["branchName"] ?? " ",
        branch: data["branch"] ?? " ",
        date_of_issue: data["date_of_issue"] ?? " ",
        status: data["status"] ?? " ",
        gender: data["gender"] ?? " ",
        isO_FP_1: data["isO_FP_1"],
        isO_FP_2: data["isO_FP_2"],
        isO_FP_3: data["isO_FP_3"],
        isO_FP_4: data["isO_FP_4"],
        fingerPrint_1: data["fingerPrint_1"],
        fingerPrint_2: data["fingerPrint_2"],
        fingerPrint_3: data["fingerPrint_3"],
        fingerPrint_4: data["fingerPrint_4"],
        image: data["image"] ?? " ",
        uid: data["uid"],
      ).toMap();
      print(data["image"]);
    } on Exception catch (e) {
      // TODO
      Map<String, dynamic> errLog = {"get Satsangi data": e};
      FirebaseLog().logError(errLog);
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
    }
  }

  Future<void> getChildList(BuildContext context) async {
    var jsonReceived;
    try {
      final pref = await SharedPreferences.getInstance();
      var token = pref.getString("token") ?? "";
      Map<String, String> m = new Map();
      m["uid"] = satsangiListData.satsangiList[satsangiListData.index].uid;
      var json = jsonEncode(m);
      print(json);
      http.Response response = await http.post(
          Uri.parse("https://api.dbidentity.in/api/childbio/getchildren"),
          body: json,
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      jsonReceived = jsonDecode(response.body);
    } on Exception catch (e) {
      // TODO
      Map<String, dynamic> errLog = {"get child list": e};
      FirebaseLog().logError(errLog);
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
    }
    if (jsonReceived != null) {
      ChildList.childList.clear();
      ChildList.childList = List.from(jsonReceived)
          .map<ChildListData>((item) => ChildListData.fromMap(item))
          .toList();
      Navigator.pushNamed(context, "/childrenList");
    }
  }

  Future<void> getSatsangisList(
      int branchid, int offset, int pageSize, BuildContext context) async {
    try {
      final pref = await SharedPreferences.getInstance();
      var token = pref.getString("token") ?? "";

      var jsonData =
          PaginaionData(branchid: branchid, offset: offset, pageSize: pageSize)
              .toJson();
      print(jsonData);
      http.Response response = await http.post(
          Uri.parse("https://api.dbidentity.in/api/uid/list"),
          body: jsonData,
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      // // var jsonReceived = jsonDecode(response.body);
      print(response.body);
      satsangiListData.satsangiList.clear();
      satsangiListData.satsangiList = List.from(jsonDecode(response.body))
          .map<SatsangiData>((item) => SatsangiData.fromMap(item))
          .toList();
    } on Exception catch (e) {
      // TODO
      Map<String, dynamic> errLog = {"get satsangi list": e};
      FirebaseLog().logError(errLog);
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
    }
    //print(satsangiListData.satsangiList[0].bioMetric_Status);
  }

  Future<bool> checkFace(String image) async {
    Map<String, String> m = new Map();
    m["img"] = image;
    print(jsonEncode(m));
    http.Response response = await http.post(
        Uri.parse("https://api.dbidentity.in/?match=v"),
        body: jsonEncode(m),
        headers: {
          'Content-type': 'application/json',
        });
    var data = jsonDecode(response.body);
    return data["result"];
  }

  getChildInfo(BuildContext context) async {
    try {
      final pref = await SharedPreferences.getInstance();
      var token = pref.getString("token") ?? "";

      var jsonData =
          jsonEncode({"uid": ChildList.childList[ChildList.index].uid});
      print(jsonData);
      http.Response response = await http.post(
          Uri.parse("https://api.dbidentity.in/api/childbio/getbiometric"),
          body: jsonData,
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      var data = jsonDecode(response.body);
      print(response.body);
      print(data["id"]);
      ChildBiometricData.data = ChildBiometricView(
        id: data["id"],
        name: data["name"],
        father_name: data["father_name"],
        image: data["image"],
        uid: data["uid"],
        gender: data["gender"],
        mobile: data["mobile"],
        dob: data["dob"],
        parent_uid_one: data["parent_uid_one"],
        parent_uid_two: data["parent_uid_two"],
        branch: data["branch"],
        first_created: data["first_created"],
        last_updated: data["last_updated"],
        isO_FP_1: data["isO_FP_1"],
        isO_FP_2: data["isO_FP_2"],
        isO_FP_3: data["isO_FP_3"],
        isO_FP_4: data["isO_FP_4"],
        fingerPrint_1: data["fingerPrint_1"],
        fingerPrint_2: data["fingerPrint_2"],
        fingerPrint_3: data["fingerPrint_3"],
        fingerPrint_4: data["fingerPrint_4"],
      ).toMap();
      //Navigator.pop(context);
      if (ChildBiometricData.data["id"] != 0 ||
          ChildBiometricData.data.isNotEmpty) {
        Navigator.pushNamed(context, "/viewChildren");
      } else {
        Navigator.pop(context);
        VxToast.show(context, msg: "child data not available");
      }
    } on Exception catch (e) {
      // TODO
      Map<String, dynamic> errLog = {"get child info": e};
      FirebaseLog().logError(errLog);
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
    }
  }

  void updateSatsangiBiometric(
      String uid,
      int iso1,
      int iso2,
      int iso3,
      int iso4,
      String finger1,
      String finger2,
      String finger3,
      String finger4,
      String faceImage,
      BuildContext context) async {
    try {
      var jsonData = SatsangiBiometricData(
              uid: uid,
              iso1: iso1,
              iso2: iso2,
              iso3: iso3,
              iso4: iso4,
              fingerprint1: finger1,
              fingerprint2: finger2,
              fingerprint3: finger3,
              fingerprint4: finger4,
              faceimage: faceImage)
          .toJson();
      final pref = await SharedPreferences.getInstance();
      var token = pref.getString("token") ?? "";

      http.Response response = await http.post(
          Uri.parse("https://api.dbidentity.in/api/uidbio/Register"),
          body: jsonData,
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      // var jsonReceived = jsonDecode(response.body);
      print("${response.body}");
    } on Exception catch (e) {
      // TODO\
      Map<String, dynamic> errLog = {"update satsangi biometric": e};
      FirebaseLog().logError(errLog);
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
    }
  }

  updateChildBiometric(
      String name,
      String dob,
      String gender,
      String uid,
      String parent,
      String uid1,
      String uid2,
      String mobile,
      int iso1,
      int iso2,
      int iso3,
      int iso4,
      String fingerprint1,
      String fingerprint2,
      String fingerprint3,
      String fingerprint4,
      String faceimage,
      BuildContext context) async {
    try {
      final pref = await SharedPreferences.getInstance();
      var token = pref.getString("token") ?? "";
      int branch = pref.getInt("branch") ?? 1;
      print(branch);
      var json = ChildJsonBiometric(
              name: name,
              dob: dob,
              Gender: gender,
              uid: uid,
              father_name: parent,
              parent_uid_one: uid1,
              parent_uid_two: uid2,
              mobile: mobile,
              branch: branch,
              ISO_FP_1: iso1,
              ISO_FP_2: iso2,
              ISO_FP_3: iso3,
              ISO_FP_4: iso4,
              FingerPrint_1: fingerprint1,
              FingerPrint_2: fingerprint2,
              FingerPrint_3: fingerprint3,
              FingerPrint_4: fingerprint4,
              FaceImage: faceimage)
          .toJson();
      print(json);

      http.Response response = await http.post(
          Uri.parse("https://api.dbidentity.in/api/childbio/Register"),
          body: json,
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      // var jsonReceived = jsonDecode(response.body);
      print("${response.body}");
    } on Exception catch (e) {
      // TODO
      Map<String, dynamic> errLog = {"update child biometric": e};
      FirebaseLog().logError(errLog);
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
    }
  }
  // Future<Uint8List> getTestImage() async {
  //   final pref = await SharedPreferences.getInstance();
  //   var token = pref.getString("token") ?? "";
  //   Map<String, String> m = new Map();
  //   m["uid"] = "TEST";
  //   var jsonData = jsonEncode(m);
  //   print(jsonData);
  //   http.Response response = await http.post(
  //       Uri.parse("https://api.dbidentity.in/api/uidbio/getbiometric"),
  //       body: jsonData,
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       });
  //   // var jsonReceived = jsonDecode(response.body);
  //   print(response.body);
  //   var jsonReceived = jsonDecode(response.body);

  //   return Base64Decoder().convert(jsonReceived["fingerPrint_1"]);
  //
  //
  // }

}
