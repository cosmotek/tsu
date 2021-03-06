import 'package:example_flutter/orgs/sqltable_structure.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

import 'package:clippy/server.dart' as clippy;

import './atoms/text.dart';
import './atoms/link.dart';
import './atoms/input.dart';
import './atoms/button.dart';
import './molecules/map.dart';
import './orgs/desktop_app.dart';
import './orgs/sqltable.dart';
import './orgs/sqlcontext.dart';
import './orgs/connection_list.dart';

Map<LogicalKeyboardKey, Function> shortcuts = {};

class CustomDialog extends StatelessWidget {
  final String title;

  CustomDialog({
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(20),
        width: 500,
        height: 500,
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[IconButton(
              icon: Icon(Icons.close, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            )]),
            Input(placeholder: "Name", onChange: (v) => print(v)),
            // Row(children: <Widget>[
            //   Input(placeholder: "Host", onChange: (v) => print(v)),
            //   Input(placeholder: "Port", onChange: (v) => print(v)),
            // ]),
            // Input(placeholder: "Database", onChange: (v) => print(v)),
            // Row(children: <Widget>[
            //   Input(placeholder: "Username", onChange: (v) => print(v)),
            //   Input(placeholder: "Password", onChange: (v) => print(v)),
            // ]),
            Button(value: "Save", onTap: () => print("save")),
          ],
        ),
      ),
    );
  }
}

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(desktopApp("Tsu SQL", App(), shortcuts));
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App>{
  SQLConfig conf = new SQLConfig(
    host: "localhost",
    port: 5432,
    database: "postgres",
    username: "postgres",
    password: "postgres",
  );

  void initState() {
    super.initState();

    
    // LogicalKeyboardKey.enter: () => print("execute..."),
    // LogicalKeyboardKey.keyC: () => clippy.write('flutter clipboard value'),
    // LogicalKeyboardKey.keyV: () async => print(await clippy.read()),
    // LogicalKeyboardKey.keyX: () => print("cut..."),
  }

  @override
  Widget build(BuildContext context) {
    shortcuts[LogicalKeyboardKey.keyS] = () => print("");

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 18),
                    child: AText(value: "Connections"),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 18, top: 10),
                    child: Button(
                      value: "Add a connection",
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => CustomDialog(title: "hello")),
                    ),
                  ),
                ],
              ),
            ],
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: ListView(
        children: <Widget>[
          SQLTableStructure(config: conf, tableName: "people"),
          SQLTable(config: conf, queryStr: "select * from people"),
          GeoMap(),
        ],
      ),
    );
  }
}