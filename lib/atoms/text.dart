import 'package:flutter/material.dart';

Widget AText({@required String value}) {
  return Text(
    value,
    style: TextStyle(
      fontFamily: 'CoreSansC55',
      fontWeight: FontWeight.w600,
      fontSize: 64.0,
      color: Color.fromRGBO(49, 210, 128, 1),
    )
  );
}