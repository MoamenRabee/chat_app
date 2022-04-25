
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



ShowToast({
  required String? text,
  Color color = Colors.green,
}) async {
  return await Fluttertoast.showToast(
      msg: "${text}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0
  );
}