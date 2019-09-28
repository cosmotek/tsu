import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import './sqlcontext.dart';
import '../molecules/table.dart';

Widget SQLTable({@required SQLConfig config, @required String queryStr, String viewName = "", String viewType = "view"}) {
  PostgreSQLConnection db = config.toPostgresConnection();

  Future tableQuery = db.open().then((_) {
    return db.mappedResultsQuery(queryStr).then((val) => val);
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
          return STable(data: snapshot.data, viewName: viewName, viewType: viewType);
      }

      return null;
    },
  );
}