import 'package:flutter/material.dart';

Widget Link({@required String value, @required Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Text(
      value,
      style: TextStyle(
        fontFamily: 'CoreSansC65',
        fontWeight: FontWeight.w400,
        fontSize: 18.0,
        color: Color.fromRGBO(0, 155, 253, 1),
        decoration: TextDecoration.underline,
      )
    ),
  );
}