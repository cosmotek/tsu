import 'package:flutter/material.dart';

Widget STable(List<Map<String, Map<String, dynamic>>> data) {
  if (data == null) {
    return Text("nothing was returned");
  }

  var header = TableRow(
    children: [
      TableCell(
        child: Container(
          color: Colors.black,
          child: Row(
            children: data[0][data[0].keys.first].keys.map((v) => Text(v, style: TextStyle(color: Colors.white))).toList(),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          )
        )
      )
    ]);

  var rows = data.map((row) {
    var rowValues = row[row.keys.first].values;
    if (rowValues != null) {
      return TableRow(
        children: [
          TableCell(
            child: Row(
              children: rowValues.map((val) => Text("$val")).toList(),
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
        ]);
    }

    return [];
  });

  return Table(
    border: TableBorder.all(color: Colors.black, width: 1.0),
    children: [header, ...rows.toList()],
  );
}