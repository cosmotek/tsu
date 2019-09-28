import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget desktopApp(String name, Widget child, Map<LogicalKeyboardKey, Function> shortcuts) {
  return RawKeyboardListener(
    focusNode: FocusNode(),
    onKey: (event) {
      if (event.runtimeType == RawKeyDownEvent && event.isControlPressed) {
        var shortcut = shortcuts[event.logicalKey];
        if (shortcut != null) {
          shortcut();
        }
      }
    },
    child: MaterialApp(
      title: name,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto',
      ),
      home: child,
      debugShowCheckedModeBanner: false,
    ),
  );
}