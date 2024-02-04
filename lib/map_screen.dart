import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:routesapp/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:routesapp/backend/Locationservice.dart';

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
      body: Column(
        children: [
          Center(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              width: ScreenWidth,
              height: ScreenHeight * 0.7,
              child: FutureBuilder(
                  future: LocationService().getLocation(),
                  builder: (context, snapshot) {
                    return FlutterMap(
                      options: MapOptions(
                          zoom: 15,
                          center: LatLng(snapshot.data?.latitude ?? 55,
                              snapshot.data?.longitude ?? 23)),
                      children: [
                        // Layer that adds the map
                        TileLayer(
                          urlTemplate:
                              "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                          userAgentPackageName:
                              'dev.fleaflet.flutter_map.example',
                        ),
                        // Layer that adds points the map
                        FutureBuilder(
                            future: LocationService().getIndanger(),
                            builder: (context, snapshot) {
                              print(snapshot.data);
                              return MarkerLayer(
                                markers: markers,
                              );
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
                  }),
            ),
          ),
          SizedBox(
            height: ScreenHeight * 0.1,
          ),
          Container(
            width: 100,
            child: IconButton(
              style: ButtonStyle(iconSize: MaterialStatePropertyAll(10)),
              color: Colors.red,
              icon: Image.asset("assets/icon.png"),
              onPressed: () async {
                final location = await LocationService().getLocation();
                setState(() {
                  markers.add(Marker(
                    point: LatLng(
                        location?.latitude ?? 0, location?.longitude ?? 0),
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
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
