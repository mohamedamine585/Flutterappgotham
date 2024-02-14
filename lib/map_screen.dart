import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:routesapp/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:web_socket_channel/io.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Raw coordinates got from  OpenRouteService
  List listOfPoints = [];

  // Conversion of listOfPoints into LatLng(Latitude, Longitude) list of points
  List<LatLng> points = [];

  // Method to consume the OpenRouteService API
  getCoordinates() async {
    // Requesting for openrouteservice api
    var response = await http.get(getRouteUrl(
        "1.243344,6.145332", '1.2160116523406839,6.125231015668568'));
    setState(() {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        listOfPoints = data['features'][0]['geometry']['coordinates'];
        points = listOfPoints
            .map((p) => LatLng(p[1].toDouble(), p[0].toDouble()))
            .toList();
      }
    });
  }

  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: ScreenHeight * 0.1,
          ),
          Center(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              width: ScreenWidth,
              height: ScreenHeight * 0.6,
              child: FutureBuilder(
                  future: Geolocator.getCurrentPosition(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.connectionState == ConnectionState.active) {
                      markers.add(Marker(
                        point: LatLng(snapshot.data?.latitude ?? 0,
                            snapshot.data?.longitude ?? 0),
                        builder: (context) => IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Text("last seen"),
                                  );
                                });
                          },
                          icon: const Icon(Icons.location_on),
                          color: Color.fromARGB(255, 13, 5, 70),
                          iconSize: 45,
                        ),
                      ));

                      return FlutterMap(
                        options: MapOptions(
                            zoom: 15,
                            center: LatLng(snapshot.data?.latitude ?? 30,
                                snapshot.data?.longitude ?? 15)),
                        children: [
                          // Layer that adds the map
                          TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            userAgentPackageName:
                                'dev.fleaflet.flutter_map.example',
                          ),
                          // Layer that adds points the map
                          StreamBuilder(
                              stream: IOWebSocketChannel.connect(
                                "ws://192.168.100.6:8081/indanger",
                              ).stream,
                              builder: (context, snapshot) {
                                if ((snapshot.connectionState ==
                                        ConnectionState.active ||
                                    snapshot.connectionState ==
                                        ConnectionState.done)) {
                                  final indangers =
                                      json.decode(snapshot.data)["dangers"]
                                          as List<dynamic>;
                                  indangers.forEach((indanger) {
                                    markers.add(Marker(
                                      point: LatLng(
                                          indanger["location"]["latitude"],
                                          indanger["location"]["longitude"]),
                                      builder: (context) => IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Text("last seen"),
                                                );
                                              });
                                        },
                                        icon: const Icon(Icons.location_on),
                                        color: Color.fromARGB(255, 172, 9, 9),
                                        iconSize: 45,
                                      ),
                                    ));
                                  });
                                  return MarkerLayer(
                                    markers: markers,
                                  );
                                } else {
                                  return Center(
                                    child: Container(
                                        width: ScreenWidth * 0.1,
                                        height: ScreenHeight * 0.2,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator())),
                                  );
                                }
                              }),

                          // Polylines layer
                          PolylineLayer(
                            polylineCulling: false,
                            polylines: [
                              Polyline(
                                  points: points,
                                  color: Colors.black,
                                  strokeWidth: 5),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Container(
                          width: ScreenWidth * 0.01,
                          height: ScreenHeight * 0.02,
                          child: Center(
                            child: LinearProgressIndicator(),
                          ));
                    }
                  }),
            ),
          ),
          SizedBox(
            height: ScreenHeight * 0.005,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: ScreenWidth * 0.15),
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
              ),
              Text("Someone needs help"),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.location_on,
                  color: Color.fromARGB(255, 47, 2, 65),
                ),
              ),
              Text("You"),
            ],
          )
        ],
      ),
    );
  }
}
