import 'package:example_flutter/orgs/sqlquerier.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:clippy/server.dart' as clippy;
import 'package:postgres/postgres.dart';

import './orgs/sqlquerier.dart';

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  var kbshortcuts = {
    LogicalKeyboardKey.keyS: () => print("save..."),
    LogicalKeyboardKey.enter: () => print("execute..."),
    LogicalKeyboardKey.keyC: () => clippy.write('flutter clipboard value'),
    LogicalKeyboardKey.keyV: () async => print(await clippy.read()),
    LogicalKeyboardKey.keyX: () => print("cut..."),
  };

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        switch (event.runtimeType) {
          case RawKeyDownEvent:
            if (event.isControlPressed) {
              var shortcut = kbshortcuts[event.logicalKey];
              if (shortcut != null) {
                shortcut();
              }
            }

            break;
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          // See https://github.com/flutter/flutter/wiki/Desktop-shells#fonts
          fontFamily: 'Roboto',
        ),
        home: MyHomePage(title: 'Tsu SQL'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// SELECT
//    COLUMN_NAME
// FROM
//    information_schema.COLUMNS
// WHERE
//    TABLE_NAME = 'city';

// select column_name, ordinal_position, column_default, is_nullable, data_type, character_maximum_length from information_schema.columns where table_name = 'people';

const tableQueryStr = """select table_name from information_schema.tables
    where table_schema not in ('information_schema', 'pg_catalog') and
    table_type = 'BASE TABLE'""";

class _MyHomePageState extends State<MyHomePage> {
  PostgreSQLConnection dbclient = new PostgreSQLConnection("localhost", 5432, "postgres", username: "postgres", password: "postgres");

  var tables = [];
  var numTabs = 1;
  var tabs = <Map<String, dynamic>>[
    { 
      "name": "example",
      "view": Icon(Icons.directions_transit)
    },
  ];

  var superDown = false;
  var open = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
          dbclient.open().then((_) {
            open = true;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: numTabs,
      child: Scaffold(
        drawer: () {
          if (open) {
            dbclient.mappedResultsQuery(tableQueryStr).then((val) {
              setState(() {
                tables = val.map((v) => v[null]["table_name"]).toList();
              });
            });

            return Drawer(
              child: ListView(
                children: <Widget>[...tables.map((table) => ListTile(title: Text(table))).toList()],
              ),
            );
          }

          return null;
        }(),
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                    isScrollable: true,
                    tabs: [
                      ...tabs.map((tab) =>
                        Row(
                          children: <Widget>[
                            Text(tab["name"]),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: numTabs == 1 ? null : () {
                                setState(() {
                                  tabs.removeAt(tabs.indexOf(tab));
                                  numTabs -= 1;
                                });
                              },
                            ),
                          ],
                        )
                      ).toList()
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        numTabs += 1;
                        tabs = [...tabs, {
                          "name": "a${numTabs}",
                          "view": Text("example ${numTabs}"),
                        }];
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          title: Text('Tabs Demo'),
        ),
        body: open
          ? TabBarView(
              children: [
                ...tabs.map((tab) => SQLQuerier(
                  pgHost: "localhost",
                  pgPort: 5432,
                  username: "postgres",
                  password: "postgres",
                )).toList(),
              ],
            )
          : Text("loading"),
      ),
    );
  }
}
