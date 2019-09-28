import 'package:flutter/material.dart';

Widget Button({@required String value, @required Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 200,
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 155, 253, 1),
          borderRadius: BorderRadius.circular(48),
        ),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'CoreSansC65',
            fontWeight: FontWeight.w400,
            fontSize: 18.0,
            color: Colors.white,
          )
        ),
      ),
    ),
  );
}