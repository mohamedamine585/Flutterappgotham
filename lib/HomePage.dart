import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:routesapp/backend/Locationservice.dart';
import 'package:routesapp/main.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:workmanager/workmanager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final channel =
      IOWebSocketChannel.connect("ws://192.168.100.6:8081/indanger");
  Map<String, dynamic>? mylocation = {
    "_id": "",
    "location": {
      "longitude": 0,
      "latitude": 0,
    },
  };
  @override
  void initState() {
    super.initState();
  }

  @override
  Timer? timer;
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: channel.stream,
        builder: (context, snapstream) {
          if (snapstream.connectionState == ConnectionState.done ||
              snapstream.connectionState == ConnectionState.active ||
              snapstream.connectionState == ConnectionState.waiting) {
            mylocation = (json.decode(snapstream.data)["mylocation"] != null)
                ? json.decode(snapstream.data)["mylocation"]
                : mylocation;

            return FutureBuilder(
                future: LocationService().getLocation(),
                builder: (context, snapshot) {
                  return Scaffold(
                      backgroundColor: Color.fromARGB(255, 8, 0, 28),
                      body: Center(
                        child: SingleChildScrollView(
                          child: Column(children: [
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              "Code Dreamers",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            RawMaterialButton(
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                padding: EdgeInsets.only(left: 40),
                                height: 70,
                                width: 150,
                                child: Text(
                                  "I'am in Danger !",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              constraints:
                                  BoxConstraints(maxHeight: 250, minWidth: 250),
                              onPressed: () {
                                if (snapshot.data != null) {
                                  _startIsolate({
                                    "longitude": snapshot.data?.longitude,
                                    "latitude": snapshot.data?.latitude,
                                    "_id": (json.decode(snapstream.data
                                                as String)["mylocation"] !=
                                            null)
                                        ? json.decode(snapshot.data as String)[
                                            "mylocation"]["_id"]
                                        : "",
                                  });
                                }
                              },
                              elevation: 2.0,
                              fillColor: const Color.fromARGB(255, 147, 14, 4),
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(50.0),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pushNamed(
                                  "mappage",
                                );
                              },
                              child: Text(
                                "Be The Batman",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(backgroundColor:
                                  MaterialStateColor.resolveWith((states) {
                                return const Color.fromARGB(255, 147, 14, 4);
                              })),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ]),
                        ),
                      ));
                });
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

// Function to start the isolate
void _startIsolate(Map<String, dynamic> position) async {
  final receivePort = ReceivePort();
  final isolate = Isolate.spawn(volumeButtonIsolate, position);
}

void volumeButtonIsolate(Map<String, dynamic> position) async {
  final channel =
      IOWebSocketChannel.connect("ws://192.168.100.6:8081/indanger");

  Stream<dynamic> data;
  String id = "";
  bool send = true;
  Timer? timer;
  channel.stream.listen((event) {
    if (id == "") {
      id = (json.decode(event)["mylocation"] != null)
          ? json.decode(event)["mylocation"]["_id"]
          : id;
    }
    if (send) {
      print(send);
      send = false;
      Timer.periodic(Duration(seconds: 30), (timer) {
        print(id);

        channel.sink.add(json.encode({
          "longitude": position["longitude"],
          "latitude": position["latitude"],
          "_id": id
        }));
      });
    }
  });
}
