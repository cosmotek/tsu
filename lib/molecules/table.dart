import 'package:flutter/material.dart';

Widget STable(List<Map<String, Map<String, dynamic>>> data) {
  if (data == null || data.length == 0) {
    return Text("nothing was returned");
  }

  var fieldNames = <String>[...data[0][data[0].keys.first].keys];
  var cols = fieldNames.map((field) {
    var children = <Widget>[
      Text(
        "${field[0].toUpperCase()}${field.substring(1)}",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
      ...data.map((rowData) {
        var index = data.indexOf(rowData);

        return Text(
          "${rowData[rowData.keys.first][field]}",
          style: TextStyle(backgroundColor: index % 2 == 1 ? Colors.white : Colors.grey[200]),
        );
      }),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }).toList() as List<Widget>;

  var fieldCols = <Widget>[];
  cols.asMap().forEach((index, val) {
    fieldCols.insert(fieldCols.length, val);
    if (index != cols.length-1) {
      fieldCols.insert(fieldCols.length, Container(color: Colors.black45, height: 50, width: 2));
    }
  });

  return Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          Chip(label: Text("view")),
          Text("\"${data[0].keys.first}\"")
        ],
      ),
      Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: fieldCols,
      ),
    ],
  );
}