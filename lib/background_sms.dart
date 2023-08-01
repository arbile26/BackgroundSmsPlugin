import 'dart:async';

import 'package:flutter/services.dart';

enum SmsStatus { sent, failed }

class BackgroundSms {
  static const MethodChannel _channel = const MethodChannel('background_sms');

  static Future<({SmsStatus status, String id})> sendMessage(
      {required String phoneNumber,
      required String message,
      required int messageId,
      int? simSlot}) async {
    try {
      String? result = await _channel.invokeMethod('sendSms', <String, dynamic>{
        "phone": phoneNumber,
        "msg": message,
        "simSlot": simSlot,
        "messageId": messageId,
      });
      return (
        status: result!.contains("Sent") ? SmsStatus.sent : SmsStatus.failed,
        id: result.split(": ")[1]
      );
    } on PlatformException catch (e) {
      print(e.toString());
      return (status: SmsStatus.failed, id: "0");
    }
  }

  static Future<bool?> get isSupportCustomSim async {
    try {
      return await _channel.invokeMethod('isSupportMultiSim');
    } on PlatformException catch (e) {
      print(e.toString());
      return true;
    }
  }
}
