import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  var containerPosition = 0.0;
  void moveContainer() {
    setState(() {
      containerPosition = containerPosition == 0.0 ? 200.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    Position? position;
    return StreamBuilder(
        stream: Geolocator.getPositionStream(),
        builder: (context, snapshot) {
          return Scaffold(
              backgroundColor: Color.fromARGB(255, 7, 0, 21),
              body: Center(
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "Code Dreamers",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  width: 180,
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 12, 2, 36),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(45),
                                      child: Container(
                                        width: 150.0,
                                        height: 150.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color.fromARGB(
                                                    255, 12, 2, 36),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(30),
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                    ),
                                                    child: Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: IconButton(
                            color: Colors.white,
                            iconSize: ScreenHeight * 0.2,
                            icon: Icon(Icons.location_on),
                            constraints:
                                BoxConstraints(maxHeight: 250, minWidth: 250),
                            onPressed: () async {
                              final instance =
                                  await SharedPreferences.getInstance();

                              await instance.setBool("canSendData",
                                  !(instance.getBool("canSendData") ?? false));

                              String dangerid = "";

                              Timer.periodic(Duration(seconds: 5),
                                  (timer) async {
                                final instance =
                                    await SharedPreferences.getInstance();
                                final canSendData =
                                    instance.get("canSendData") as bool;
                                print(canSendData);
                                if (!canSendData) {
                                  timer.cancel();
                                } else if (position?.latitude !=
                                        snapshot.data?.latitude ||
                                    snapshot.data?.longitude !=
                                        snapshot.data?.longitude) {
                                  position = snapshot.data;
                                  final response = await http.post(
                                      Uri.parse(
                                          "http://192.168.100.6:8080/indanger"),
                                      headers: {
                                        'Content-Type': 'application/json'
                                      },
                                      body: json.encode({
                                        "longitude": position?.longitude,
                                        "latitude": position?.latitude,
                                        "dangerid": dangerid
                                      }));
                                  print(response.body);
                                  dangerid =
                                      json.decode(response.body)["dangerid"];
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: ScreenHeight * 0.08,
                      width: ScreenWidth * 0.7,
                      child: FloatingActionButton(
                        onPressed: () async {
                          Navigator.of(context).pushNamed(
                            "mappage",
                          );
                        },
                        child: Text(
                          "Help Someone",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color.fromARGB(48, 67, 0, 200),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
                ),
              ));
        });
  }
}

Future<void> StartBackgroundTask() async {}
