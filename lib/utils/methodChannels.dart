import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

import '../data/fingerData.dart';

class MethodChannels {
  static const MethodChannel _channel =
      MethodChannel('com.example.dayalbaghidregistration/getBitmap');
  Future<int> init() async {
    final int res = await _channel.invokeMethod('init');
    return res;
  }

  Future<FingerData> startAutoCapture(
      BuildContext context, int timeOut, bool detectFastFinger) async {
    var data = <String, dynamic>{
      'detectFinger': detectFastFinger,
      'timeout': timeOut
    };
    try {
      final res = await _channel.invokeMethod('autoCapture', data);
      print("$res");
      return Future.value(FingerData.load(res));
    } on PlatformException catch (e) {
      // TODO

      VxToast.show(context, msg: "${e.message}");
      return Future.value();
    }
  }

  Future<int> matchISO(
      Uint8List firstTemplate, Uint8List secondTemplate) async {
    var data = <String, dynamic>{
      'firstTemplate': firstTemplate,
      'secondTemplate': secondTemplate
    };
    final res = await _channel.invokeMethod('matchISO', data);
    print('matchISO ' + res.toString());
    return Future.value(res);
  }

  Future<String> getErrorMsg(int errorCode) async {
    final res =
        await _channel.invokeMethod('getErrorMessage', {'error': errorCode});
    return Future.value(res);
  }

  Future<int> stopAutoCapture() async {
    final res = await _channel.invokeMethod('stopAutoCapture');
    return Future.value(res);
  }

  Future<int> unInit() async {
    return Future.value(await _channel.invokeMethod('unInit'));
  }

  Future<dynamic> getPhoneData() async {
    final res = await _channel.invokeMethod('getPhoneData');
    return Future.value(res);
  }

  Future dispose() async {
    await _channel.invokeMethod('dispose');
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
