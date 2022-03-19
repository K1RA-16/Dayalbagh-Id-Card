// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dayalbaghidregistration/pages/addChild.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:dayalbaghidregistration/apiAccess/keyEncrypt.dart';
import 'package:dayalbaghidregistration/data/downloadLink.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:dayalbaghidregistration/apiAccess/firebaseLogApis.dart';
import 'package:dayalbaghidregistration/data/SatsangiBiometricData.dart';
import 'package:dayalbaghidregistration/data/authData.dart';
import 'package:dayalbaghidregistration/data/childBiometricViewData.dart';
import 'package:dayalbaghidregistration/data/childJsonBiometricData.dart';
import 'package:dayalbaghidregistration/data/childListData.dart';
import 'package:dayalbaghidregistration/data/paginationData.dart';
import 'package:dayalbaghidregistration/data/satsangiData.dart';
import 'package:dayalbaghidregistration/data/satsangiGetBiometricData.dart';
import 'package:dayalbaghidregistration/pages/listSatsangis.dart';

import '../data/search.dart';

String version = "2.0.0.0";

class PostApi {
  //logs in the user and saves the token to shared Pref...
  Future<int> login(
      String username, String password, BuildContext context) async {
    var jsonReceived;
    var check = false;
    try {
      if (username.isNotEmpty && password.isNotEmpty) {
        var jsonData = AuthData(
          username: username,
          password: password,
          version: version,
        ).toJson();
        Map<String, String> headers = {'Content-type': 'application/json'};
        check = await myCustomImplementation(
            "https://api.dbidentity.in/api/login/authenticate", headers);
        if (check) {
          http.Response response = await http.post(
              Uri.parse("https://api.dbidentity.in/api/login/authenticate"),
              body: jsonData,
              headers: {
                'Content-type': 'application/json',
              }).timeout(const Duration(seconds: 10));

          if (response.statusCode == 400) {
            //DownloadLink.link = response.body.toString();
            print(response.body.toString());
            if (response.body.toString().characters.first == '{') {
              jsonReceived = await jsonDecode(response.body);

              if (jsonReceived["message"] ==
                  "Username or password is incorrect")
                VxToast.show(context, msg: "Username or password is incorrect");

              return 300; // username/pass incorrect
            }
            return 400;
          } else {
            jsonReceived = await jsonDecode(response.body);
            if (jsonReceived["message"] ==
                "Username or password is incorrect") {
              VxToast.show(context, msg: "Username or password is incorrect");

              return 300;
            } // username/pas
          }
        }
      }
    } on TimeoutException catch (e) {
      VxToast.show(context, msg: "Request Timeout");
    } catch (e) {
      // TODO
      print(e);
      FirebaseLog().logError("login error", e.toString());
      return 401;
    }
    if (check && jsonReceived != null) {
      EncryptedSharedPreferences encryptedSharedPreferences =
          EncryptedSharedPreferences();
      await encryptedSharedPreferences.setString(
          "token", jsonReceived["token"]);
      await encryptedSharedPreferences.setString("userid", username);

      if (username != "" && password != "")
        Navigator.pushNamed(context, "/home");
      else if (username == "")
        VxToast.show(context, msg: "Please enter username");
      else if (password == "")
        VxToast.show(context, msg: "Please enter password");
      return 200;
    } else {
      if (username == "" && password == "")
        VxToast.show(context, msg: "please enter username & password");
      else if (username == "")
        VxToast.show(context, msg: "Please enter username");
      else if (password == "")
        VxToast.show(context, msg: "Please enter password");
      return 401;
    }
  }

  //gets the branch list of that particular user
  Future<List<dynamic>> getBranches(BuildContext context, int index) async {
    var jsonReceived = [];
    var token = " ";
    var check = false;
    try {
      try {
        EncryptedSharedPreferences encryptedSharedPreferences =
            EncryptedSharedPreferences();
        token = await encryptedSharedPreferences.getString("token");
      } catch (e) {
        // TODO
      }
      Map<String, String> headers = {'Content-type': 'application/json'};
      check = await myCustomImplementation(
          "https://api.dbidentity.in/api/branch/list", headers);
      if (check) {
        final response = await http.get(
            Uri.parse('https://api.dbidentity.in/api/branch/list'),
            headers: {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $token',
            }).timeout(const Duration(seconds: 10));
        jsonReceived = jsonDecode(response.body);
      }
    } on TimeoutException catch (e) {
      VxToast.show(context, msg: "Request Timeout");
    } catch (e) {
      // TODO

      FirebaseLog().logError("get branches error", e.toString());
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      List<dynamic> m = [];
      return m;
    }
    if (check) {
      if (index == 0) {
        Navigator.pushNamed(context, "/home");
      }
    }
    return jsonReceived;
  }

  Future<bool> getstsangiData(BuildContext context) async {
    var data;
    var check = false;
    var token;
    try {
      try {
        EncryptedSharedPreferences encryptedSharedPreferences =
            EncryptedSharedPreferences();
        token = await encryptedSharedPreferences.getString("token");
      } catch (e) {
        // TODO
      }

      Map<String, String> m = new Map();
      m["uid"] = satsangiListData.satsangiList[satsangiListData.index].uid;
      var json = jsonEncode(m);
      print(json);
      Map<String, String> headers = {'Content-type': 'application/json'};
      check = await myCustomImplementation(
          "https://api.dbidentity.in/api/uidbio/getbiometric", headers);
      if (check) {
        http.Response response = await http.post(
            Uri.parse("https://api.dbidentity.in/api/uidbio/getbiometric"),
            body: json,
            headers: {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $token',
            }).timeout(const Duration(seconds: 15));
        data = jsonDecode(response.body);
        print(data);
      }
    } on TimeoutException catch (e) {
      VxToast.show(context, msg: "Request Timeout");
      return false;
    } catch (e) {
      // TODO

      FirebaseLog().logError("get Satsangi data", e.toString());
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      return false;
    }
    if (check && data != null) {
      SatsangiGetBiometricMap.data = SatsangiGetBiometric(
        name: data["name"],
        father_Or_Spouse_Name: data["father_Or_Spouse_Name"],
        dob: data["dob"],
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
      print(data["fingerPrint_1"]);
      return true;
    }
    return false;
  }

  Future<bool> getChildList(BuildContext context) async {
    var jsonReceived;
    var token;
    var check = false;
    try {
      try {
        EncryptedSharedPreferences encryptedSharedPreferences =
            EncryptedSharedPreferences();
        token = await encryptedSharedPreferences.getString("token");
        var branch = await encryptedSharedPreferences.getString("branch");
        print("branch get $branch");
      } catch (e) {
        // TODO
      }

      Map<String, String> m = new Map();
      m["uid"] = satsangiListData.satsangiList[satsangiListData.index].uid;
      var json = jsonEncode(m);
      print(json);
      Map<String, String> headers = {'Content-type': 'application/json'};
      check = await myCustomImplementation(
          "https://api.dbidentity.in/api/childbio/getchildren", headers);
      if (check) {
        http.Response response = await http.post(
            Uri.parse("https://api.dbidentity.in/api/childbio/getchildren"),
            body: json,
            headers: {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $token',
            }).timeout(const Duration(seconds: 10));
        jsonReceived = jsonDecode(response.body);
      } else {
        return false;
      }
    } on TimeoutException catch (e) {
      VxToast.show(context, msg: "Request Timeout");
    } catch (e) {
      // TODO

      FirebaseLog().logError("get child list error", e.toString());
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      return false;
    }
    if (jsonReceived != null && check) {
      ChildList.childList.clear();
      ChildList.childList = List.from(jsonReceived)
          .map<ChildListData>((item) => ChildListData.fromMap(item))
          .toList();
      return true;
    }
    return false;
  }

  Future<void> getSatsangisList(String branchid, int offset, int pageSize,
      BuildContext context, int index) async {
    var jsonReceived;
    var check = false;
    var token;
    try {
      try {
        EncryptedSharedPreferences encryptedSharedPreferences =
            EncryptedSharedPreferences();
        token = await encryptedSharedPreferences.getString("token");
        await encryptedSharedPreferences.setString("branch", branchid);
      } catch (e) {
        // TODO
      }

      var jsonData =
          PaginaionData(branch: branchid, Offset: offset, PageSize: pageSize)
              .toJson();
      print(jsonData);
      Map<String, String> headers = {'Content-type': 'application/json'};
      check = await myCustomImplementation(
          "https://api.dbidentity.in/api/uid/list", headers);
      if (check) {
        http.Response response = await http.post(
            Uri.parse("https://api.dbidentity.in/api/uid/list"),
            body: jsonData,
            headers: {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $token',
            }).timeout(const Duration(seconds: 10));
        jsonReceived = jsonDecode(response.body);
        print(response.body);
      }
    } on TimeoutException catch (e) {
      VxToast.show(context, msg: "Request Timeout");
    } catch (e) {
      FirebaseLog().logError("get satsangi list error", e.toString());
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      return;
    }
    if (check) {
      if (jsonReceived != null) {
        satsangiListData.satsangiList.clear();
        satsangiListData.satsangiList = List.from(jsonReceived)
            .map<SatsangiData>((item) => SatsangiData.fromMap(item))
            .toList();

        if (index == 1) {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    ListSatsangis(branchId: branchid),
              ));
        }
      }
    }

    //print(satsangiListData.satsangiList[0].bioMetric_Status);
  }

  Future<void> search(
      String branchid, String name, BuildContext context) async {
    var jsonReceived;
    var token;
    var check = false;
    try {
      try {
        EncryptedSharedPreferences encryptedSharedPreferences =
            EncryptedSharedPreferences();
        token = await encryptedSharedPreferences.getString("token");
      } catch (e) {
        // TODO
      }
      // var branch = await encryptedSharedPreferences.getString("branch");

      var jsonData = Search(branch: branchid, Name: name).toJson();
      print(jsonData);
      Map<String, String> headers = {'Content-type': 'application/json'};
      check = await myCustomImplementation(
          "https://api.dbidentity.in/api/uid/search", headers);
      if (check) {
        http.Response response = await http.post(
            Uri.parse("https://api.dbidentity.in/api/uid/search"),
            body: jsonData,
            headers: {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $token',
            }).timeout(const Duration(seconds: 10));
        jsonReceived = jsonDecode(response.body);
        print(response.body);
      }
    } on TimeoutException catch (e) {
      VxToast.show(context, msg: "Request Timeout");
    } catch (e) {
      FirebaseLog().logError("search satsangi error", e.toString());
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      return;
    }
    if (check) {
      satsangiListData.satsangiList.clear();
      satsangiListData.satsangiList = List.from(jsonReceived)
          .map<SatsangiData>((item) => SatsangiData.fromMap(item))
          .toList();
    }
  }

  Future<bool> checkFace(String image, BuildContext context) async {
    Map<String, String> m = new Map();
    m["img"] = image;
    var data;
    var check = false;
    print(jsonEncode(m));
    try {
      Map<String, String> headers = {'Content-type': 'application/json'};
      check =
          await myCustomImplementation("https://api.dbidentity.in", headers);
      if (check) {
        http.Response response = await http.post(
            Uri.parse("https://api.dbidentity.in/?match=v"),
            body: jsonEncode(m),
            headers: {
              'Content-type': 'application/json',
            }).timeout(const Duration(seconds: 60));
        data = jsonDecode(response.body);
        print(response.statusCode);
        print("if true ${data["result"]}");
      }
    } on TimeoutException catch (e) {
      // TODO
      print("timeout");
      return false;
    }
    print("face result ${data["result"]}");
    print(check);
    if (check)
      return data["result"];
    else
      return false;
  }

  Future<bool> getChildInfo(BuildContext context) async {
    var data;
    var token;
    var check = false;
    try {
      try {
        EncryptedSharedPreferences encryptedSharedPreferences =
            EncryptedSharedPreferences();
        token = await encryptedSharedPreferences.getString("token");
      } catch (e) {
        // TODO
      }

      var jsonData =
          jsonEncode({"uid": ChildList.childList[ChildList.index].uid});
      print(jsonData);
      Map<String, String> headers = {'Content-type': 'application/json'};
      check = await myCustomImplementation(
          "https://api.dbidentity.in/api/childbio/getbiometric", headers);
      if (check) {
        http.Response response = await http.post(
            Uri.parse("https://api.dbidentity.in/api/childbio/getbiometric"),
            body: jsonData,
            headers: {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $token',
            }).timeout(const Duration(seconds: 10));
        data = jsonDecode(response.body);
        print(response.body);
        print(data["id"]);
      }
    } on TimeoutException catch (e) {
      VxToast.show(context, msg: "Request Timeout");
      return false;
    } catch (e) {
      // TODO
      //Map<String, dynamic> errLog = {"get child info": e};
      FirebaseLog().logError("get child info", e.toString());
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      return false;
    }
    if (check) {
      ChildBiometricData.data = ChildBiometricView(
        id: data["id"],
        name: data["name"],
        father_name: data["father_name"],
        image: data["image"],
        uid: data["uid"],
        gender: data["gender"],
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
        return true;
      } else {
        return false;
      }
    } else
      return false;
  }

  Future<void> updateSatsangiBiometric(
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
      String concent,
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
              concent: concent,
              faceimage: faceImage)
          .toJson();
      var token;
      var check = false;
      try {
        EncryptedSharedPreferences encryptedSharedPreferences =
            EncryptedSharedPreferences();
        token = await encryptedSharedPreferences.getString("token");
      } catch (e) {
        // TODO
      }
      // var branch = await encryptedSharedPreferences.getString("branch");
      Map<String, String> headers = {'Content-type': 'application/json'};
      check = await myCustomImplementation(
          "https://api.dbidentity.in/api/uidbio/Register", headers);
      if (check) {
        http.Response response = await http.post(
            Uri.parse("https://api.dbidentity.in/api/uidbio/Register"),
            body: jsonData,
            headers: {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $token',
            }).timeout(const Duration(seconds: 10));
        // var jsonReceived = jsonDecode(response.body);
        if (response.statusCode == 400) {
          VxToast.show(context, msg: "Details not updated please try again");
        } else if (response.statusCode == 200) {
          VxToast.show(context, msg: "Details updated");
        }
        print("${response.body}");
      }
    } on TimeoutException catch (e) {
      VxToast.show(context, msg: "Request Timeout");
    } catch (e) {
      // TODO\
      //Map<String, dynamic> errLog = {: e};
      FirebaseLog().logError("update satsangi biometric", e.toString());
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      return;
    }
    Navigator.pop(context);
  }

  updateChildBiometric(
      String name,
      String dob,
      String gender,
      String uid,
      String parent,
      String uid1,
      String uid2,
      int iso1,
      int iso2,
      int iso3,
      int iso4,
      String fingerprint1,
      String fingerprint2,
      String fingerprint3,
      String fingerprint4,
      String faceimage,
      String concent,
      BuildContext context) async {
    var token;

    var check = false;
    try {
      try {
        EncryptedSharedPreferences encryptedSharedPreferences =
            EncryptedSharedPreferences();
        token = await encryptedSharedPreferences.getString("token");
      } catch (e) {
        // TODO
      }
      var branch = satsangiListData.satsangiList[0].branch;
      print("branch ${token}");

      var json = ChildJsonBiometric(
              name: name,
              dob: dob,
              Gender: gender,
              uid: uid,
              father_name: parent,
              parent_uid_one: uid1,
              parent_uid_two: uid2,
              branch: branch,
              ISO_FP_1: iso1,
              ISO_FP_2: iso2,
              ISO_FP_3: iso3,
              ISO_FP_4: iso4,
              FingerPrint_1: fingerprint1,
              FingerPrint_2: fingerprint2,
              FingerPrint_3: fingerprint3,
              FingerPrint_4: fingerprint4,
              FaceImage: faceimage,
              concent: concent)
          .toJson();
      print(json);
      var code;
      Map<String, String> headers = {'Content-type': 'application/json'};
      check = await myCustomImplementation(
          "https://api.dbidentity.in/api/childbio/Register", headers);
      if (check) {
        http.Response response = await http.post(
            Uri.parse("https://api.dbidentity.in/api/childbio/Register"),
            body: json,
            headers: {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $token',
            }).timeout(const Duration(seconds: 10));
        // var jsonReceived = jsonDecode(response.body);

        code = response.statusCode;
        print("code $code");
        if (code == 400) {
          //DownloadLink.link = response.body.toString();
          VxToast.show(context,
              msg: "second parent uid wrong / error updating");
          Navigator.pop(context);
          //VxToast.show(context, msg: "Second parent uid wrong");
          return;
        } else if (code == 200) {
          VxToast.show(context, msg: "Details updated");
        }
      }
    } on TimeoutException catch (e) {
      VxToast.show(context, msg: "Request Timeout");
      Navigator.pop(context);
    } catch (e) {
      // TODO
      // Map<String, dynamic> errLog = {"update child biometric": e};

      FirebaseLog().logError("update child biometric", e.toString());
      //VxToast.show(context, msg: "null");
      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      return;
    }

    Navigator.pop(context);
    // VxToast.show(context, msg: "child updated");
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

  Future<bool> myCustomImplementation(
    String url,
    Map<String, String> headers,
  ) async {
    print("checking");
    try {
      final secure = await HttpCertificatePinning.check(
          serverURL: url,
          headerHttp: headers,
          sha: SHA.SHA256,
          allowedSHAFingerprints: Keys().allowedSHAFingerprints,
          timeout: 50);
      print("final $secure");
      if (secure.contains("CONNECTION_SECURE")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
