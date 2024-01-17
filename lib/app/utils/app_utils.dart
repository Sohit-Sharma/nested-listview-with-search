import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_strings.dart';

class AppUtils{

  static showToast({message}) {
    if (message.toString().trim().isEmpty) {
      return;
    }
    if (message.toString().toLowerCase().contains("dio")) {
      return;
    }
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16);
  }

  static showLoader({msg}) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..loadingStyle =
          EasyLoadingStyle.custom
      ..backgroundColor = Colors.black.withOpacity(0.9)
      ..indicatorColor = Colors.white
      ..indicatorType = EasyLoadingIndicatorType.ripple
      ..maskColor = Colors.black.withOpacity(0.9)
      ..textColor = Colors.white
      ..textStyle = const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      )
      ..dismissOnTap = false
      ..userInteractions = false;
    EasyLoading.show(status: msg ?? AppStrings.loading);
  }

  static hideLoader() {
    EasyLoading.dismiss();
  }

}