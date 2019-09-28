import 'package:flutter/material.dart';
import 'package:objectdb/objectdb.dart';
import 'package:path/path.dart' as path;
import 'dart:io' show Platform;

final String homeDir = Platform.environment["HOME"];
// final db = ObjectDB(path.join(homeDir, ".tsusql/database.db"));

// db.open();
// db.

Widget ConnectionChooser(BuildContext context) {
  return Scaffold(
    body: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
              child: Text("Add a connection"),
              onPressed: () {
                print("pressed");
              },
            ),
          ],
        ),
      ],
    ),
  );
}

