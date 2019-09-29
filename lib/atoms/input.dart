import 'package:flutter/material.dart';

Widget Input({@required String placeholder, @required Function onChange}) {
  return TextField(
    style: TextStyle(
      fontFamily: 'CoreSansC55',
      fontWeight: FontWeight.w400,
      // color: Color.fromRGBO(49, 210, 128, 1),
      color: Colors.black,
    ),
    decoration: InputDecoration(
      //Add th Hint text here.
      hintText: placeholder,
      border: OutlineInputBorder(),
    ),
  );
}

