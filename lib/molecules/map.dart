import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';

Widget GeoMap() {
  return Container(
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
    ),
    child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                          color: Colors.green[500],
                        ),
                        child: Text("visualization/geomap", style: TextStyle(color: Colors.white)),
                      ),
                      Text("\"example\"")
                    ],
                  ),
                  Text(
                    "_ rows returned",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              width: constraints.maxWidth,
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(51.5, -0.09),
                    zoom: 5.0,
                  ),
                  layers: [
                    TileLayerOptions(
                      tileProvider: NetworkTileProvider(),
                      urlTemplate: "https://api.mapbox.com/styles/v1/rucuriousyet/civr9jhaq005p2jm91r1q2j54/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicnVjdXJpb3VzeWV0IiwiYSI6ImNpdm83MjFwYzAxMnQyeXFyaDR0ZmFxbjkifQ.Ak3DcaxXheiKmTW2TIKY9A",
                      // urlTemplate: "https://api.mapbox.com/styles/v1/rucuriousyet/ck15ozlow33tj1cph5cpt2y79/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicnVjdXJpb3VzeWV0IiwiYSI6ImNpdm83MjFwYzAxMnQyeXFyaDR0ZmFxbjkifQ.Ak3DcaxXheiKmTW2TIKY9A",
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(51.5, -0.09),
                          builder: (ctx) =>
                          Container(
                            child: FlutterLogo(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  ); 
}