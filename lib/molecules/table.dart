import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

double calcWidth(BuildContext context, String msg) {
  // self-defined constraint
  final constraints = BoxConstraints(
    maxWidth: 800.0, // maxwidth calculated
    minHeight: 30.0,
    minWidth: 0.0,
  );

  final richTextWidget =
      Text.rich(TextSpan(text: msg)).build(context) as RichText;

  final renderObject = richTextWidget.createRenderObject(context);
  renderObject.layout(constraints);

  final boxes = renderObject.getBoxesForSelection(TextSelection(
      baseOffset: 0, extentOffset: TextSpan(text: msg).toPlainText().length));

  return (boxes.last.right - boxes.first.left).ceilToDouble();
}

class STable extends StatelessWidget {
  final List<Map<String, Map<String, dynamic>>> data;
  final String viewName;
  final String viewType;

  STable({Key key, this.data, this.viewName, this.viewType = "view"}) : super(key: key);

  Widget build(BuildContext context) {
    if (data == null || data.length == 0) {
      return Text("nothing was returned");
    }

    var tableHeight = ((data.length * 32.0) + 32.0);
    var fieldNames = <String>[...data[0][data[0].keys.first].keys];

    var fieldSizes = fieldNames.map((field) {
      var largest = calcWidth(context, field);
      data.forEach((rowData) {
        var next = calcWidth(context, "${rowData[rowData.keys.first][field]}");

        if (next > largest) {
          largest = next;
        }
      });

      return largest;
    }).toList();

    var cols = fieldNames.map((field) {
      var fieldSize = fieldSizes[fieldNames.indexOf(field)].ceilToDouble();
      var children = <Widget>[
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
          width: fieldSize + 25,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Text(
            "${field[0].toUpperCase()}${field.substring(1)}",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        ...data.map((rowData) {
          var index = data.indexOf(rowData);

          return Container(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            width: fieldSize + 25,
            decoration: BoxDecoration(
              color: index % 2 == 1 ? Colors.white : Colors.grey[100],
            ),
            child: Text(
              "${rowData[rowData.keys.first][field]}",
            ),
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
        fieldCols.insert(fieldCols.length, Container(color:  Colors.grey[200], height: tableHeight, width: 1));
      }
    });

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    padding: EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: viewType == "schema" ? Colors.red[500] : Color.fromRGBO(0, 155, 253, 1),
                    ),
                    child: Text(viewType, style: TextStyle(color: Colors.white)),
                  ),
                  Text("\"${viewName == "" ? data[0].keys.first : viewName}\"")
                ],
              ),
              Text(
                "${data.length} rows returned",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: fieldCols,
          ),
        ],
      ),
    );
  }
}
