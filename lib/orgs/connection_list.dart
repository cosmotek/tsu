import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/src/record_snapshot_impl.dart';
import 'package:path/path.dart' as path;
import 'dart:io' show Platform;

final String homeDir = Platform.environment["HOME"];
final String dbPath = path.join(homeDir, ".tsusql/database.db");

Map<String,dynamic> flatten(SembastRecordSnapshot<int, Map<String,dynamic>> input) {
  return input.value;
}

Widget ConnectionList() {
  DatabaseFactory factory = createDatabaseFactoryIo();
  Future tableQuery = factory.openDatabase(dbPath).then((db) {
    var store = intMapStoreFactory.store('connections');

    db.transaction((txn) async {
      await store.add(txn, {
        "id": new DateTime.now().millisecondsSinceEpoch,
        "name": "example connection",
        "type": "postgres",
      });

      await store.add(txn, {
        "id": new DateTime.now().millisecondsSinceEpoch,
        "name": "example connection 2",
        "type": "postgres",
      });

      await store.add(txn, {
        "id": new DateTime.now().millisecondsSinceEpoch,
        "name": "example connection 3",
        "type": "postgres",
      });
    });

    return store.find(db, finder: Finder(
      // filter
      sortOrders: [SortOrder('id')],
    ));
  });

  return FutureBuilder<dynamic>(
    future: tableQuery,
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return Text('Press button to start.');
        case ConnectionState.active:
        case ConnectionState.waiting:
          return Text('Awaiting result...');
        case ConnectionState.done:
          if (snapshot.hasError)
            return Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            );
          return ListView(children: <Widget>[
            ...snapshot.data.map((row) => flatten(row))
              .map((row) => Container(
                margin: EdgeInsets.all(5),
                child: Row(children: <Widget>[
                  CircleAvatar(child: Text("Pg", style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
                  Column(children: <Widget>[
                    Text("${row["name"]}"),
                    Text("127.0.0.1: postgres"),
                  ]),
                ]),
              ))
              .toList()
          ]);
      }

      return null;
    },
  );
}