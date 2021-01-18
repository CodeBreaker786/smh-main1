import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showSnackBar({context, String value, Icon icon, bool isError=false}) {
  Flushbar(
    margin: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
    borderRadius: 5,
    message: value,
    duration: Duration(seconds: 3),
    backgroundColor: Colors.red,
    backgroundGradient: isError
        ? LinearGradient(colors: [Colors.redAccent, Colors.red])
        : LinearGradient(colors: [Colors.green, Colors.green.shade100]),
    icon: icon,
  )..show(context);
}
