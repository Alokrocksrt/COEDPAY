import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happyadmin/shared/global.dart';

fullButton(
    {required String title,
    required Function onPressed,
    required Color color}) {
  return Container(
    width: 400,
    height: 60,
    child: RaisedButton(
      color: color,
      splashColor: color == Colors.black
          ? Global.mainColor.withOpacity(0.4)
          : Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 15,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        onPressed();
      },
    ),
  );
}
