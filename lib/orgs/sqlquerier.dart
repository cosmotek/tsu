// import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import '../molecules/table.dart';

class SQLQuerier extends StatefulWidget {
  final String pgHost;
  final int pgPort;
  final String username;
  final String password;

  SQLQuerier({Key key, this.pgHost, this.pgPort, this.username, this.password}): super(key: key);

  @override
  _SQLQuerierState createState() => _SQLQuerierState();
}

class _SQLQuerierState extends State<SQLQuerier> {
  PostgreSQLConnection pgdb;

  var queryStr = "";
  var errStr = "";
  var result = <Map<String, Map<String, dynamic>>>[];
  var open = false;

  void initState() {
    pgdb = new PostgreSQLConnection(widget.pgHost, widget.pgPort, "postgres", username: widget.username, password: widget.password);
    
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
          pgdb.open().then((_) {
            setState(() {
              open = true;
            });
          });
        });
  }

  void _query(String query) {
    pgdb.mappedResultsQuery(query)
      .then((v) {
        print(v);
        setState(() {
          result = v;
          errStr = "";
        });
      })
      .catchError((e) {
        setState(() {
          errStr = e.toString();
          result = null;
        });
      });
  }
  
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
            minLines: 8,
            maxLines: 256,
            // maxLines: null,
            // expands: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'SQL',
            ),
            keyboardType: TextInputType.multiline,
            onChanged: (val) {
              setState(() {
                queryStr = val;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("No results."),
              open
              ? RaisedButton(
                child: Text("execute"),
                onPressed:() {
                  _query(queryStr);
                },
              )
              : Text("connecting"),
            ],
          ),
          Text(
            errStr,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          result.length > 0 ? SQLTable(result) : Text("No results returned..."),
        ],
      ),
    );
  }
}
