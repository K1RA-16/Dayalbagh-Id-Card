import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dayalbaghidregistration/data/authData.dart';
import 'package:dayalbaghidregistration/data/paginationData.dart';
import 'package:dayalbaghidregistration/data/satsangiData.dart';
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

// Save an integer value to 'counter' key.
        await prefs.setString("token", jsonReceived["token"]);
        Navigator.pushNamed(context, "/home");
      }
    }
  }

  //gets the branch list of that particular user
  Future<List<dynamic>> getBranches() async {
    final pref = await SharedPreferences.getInstance();
    var token = pref.getString("token") ?? "";

    final response = await http
        .get(Uri.parse('https://api.dbidentity.in/api/branch/list'), headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    // // var jsonReceived = jsonDecode(response.body);
    print(response.body);
    return jsonDecode(response.body);
  }

  Future<void> getSatsangisList(int branchid, int offset, int pageSize) async {
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
    //print(satsangiListData.satsangiList[0].bioMetric_Status);
  }

  Future<String> updateBiometric(
      String uid,
      int iso1,
      int iso2,
      int iso3,
      int iso4,
      File finger1,
      File finger2,
      File finger3,
      File finger4,
      File faceImage) async {
    final pref = await SharedPreferences.getInstance();
    var token = pref.getString("token") ?? "";

    Uri uri = Uri.parse('https://api.dbidentity.in/api/uidbio/Register');

    http.MultipartRequest request = new http.MultipartRequest('POST', uri);

    request.headers['authorization'] = token;
    request.fields['UID'] = uid;
    request.fields['ISO_FP_1'] = "$iso1";
    request.fields['ISO_FP_2'] = "$iso2";
    request.fields['ISO_FP_3'] = "$iso3";
    request.fields['ISO_FP_4'] = "$iso4";

    request.files
        .add(await http.MultipartFile.fromPath('FingerPrint_1', finger1.path));
    request.files
        .add(await http.MultipartFile.fromPath('FingerPrint_2', finger2.path));
    request.files
        .add(await http.MultipartFile.fromPath('FingerPrint_3', finger3.path));
    request.files
        .add(await http.MultipartFile.fromPath('FingerPrint_4', finger4.path));
    request.files
        .add(await http.MultipartFile.fromPath('FaceImage', faceImage.path));

    http.StreamedResponse response = await request.send();

    print(response.statusCode);
    return "${response.statusCode}";
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
  // }
}
