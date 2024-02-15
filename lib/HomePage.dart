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

  String dangerid = "";

  bool showwatchme = false;

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    Position? position;
    return StreamBuilder(
        stream: Geolocator.getPositionStream(),
        builder: (context, snapshot) {
          return FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, fsnapshot) {
                showwatchme = fsnapshot.data?.getBool("canSendData") ?? false;
                return Scaffold(
                    backgroundColor: Color.fromARGB(255, 7, 0, 21),
                    body: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black,
                            Color.fromARGB(204, 134, 18, 155)
                          ])),
                      child: Center(
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
                            (!showwatchme)
                                ? Container(
                                    height: ScreenHeight * 0.4,
                                    width: ScreenWidth * 0.5,
                                    child: TextButton(
                                      onPressed: () async {
                                        await fsnapshot.data
                                            ?.setBool("canSendData", true);

                                        showwatchme = false;
                                        _showSnackBar(
                                            context,
                                            "Your location is being tracked",
                                            showwatchme);
                                        setState(() {});
                                        dangerid = "";
                                        Timer.periodic(Duration(seconds: 5),
                                            (timer) async {
                                          final instance =
                                              await SharedPreferences
                                                  .getInstance();
                                          final CansendDAta = instance
                                              .get("canSendData") as bool;
                                          print(CansendDAta);
                                          if (!CansendDAta) {
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
                                                  'Content-Type':
                                                      'application/json'
                                                },
                                                body: json.encode({
                                                  "longitude":
                                                      position?.longitude,
                                                  "latitude":
                                                      position?.latitude,
                                                  "dangerid": dangerid
                                                }));
                                            print(response.body);
                                            dangerid = json.decode(
                                                response.body)["dangerid"];
                                          }
                                        });
                                      },
                                      child: Text(
                                        "Watch me",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.red),
                                      ),
                                    ),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                  )
                                : Stack(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(30),
                                          child: Container(
                                            width: 200.0,
                                            height: 200.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Container(
                                                width: 180,
                                                height: 140.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromARGB(
                                                      255, 12, 2, 36),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            45),
                                                    child: Container(
                                                      width: 150.0,
                                                      height: 150.0,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 255, 255, 255),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Container(
                                                            width: 100.0,
                                                            height: 100.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      12,
                                                                      2,
                                                                      36),
                                                            ),
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        30),
                                                                child:
                                                                    Container(
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    width: 10,
                                                                    height: 10,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .red,
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
                                          constraints: BoxConstraints(
                                              maxHeight: 250, minWidth: 250),
                                          onPressed: () async {
                                            await fsnapshot.data
                                                ?.setBool("canSendData", false);
                                            setState(() {});
                                            await http.delete(
                                                Uri.parse(
                                                    "http://192.168.100.6:8080/indanger"),
                                                headers: {
                                                  'Content-Type':
                                                      'application/json'
                                                },
                                                body: json.encode(
                                                    {"dangerid": dangerid}));
                                            await fsnapshot.data
                                                ?.setBool("canSendData", true);

                                            setState(() {});
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
                      ),
                    ));
              });
        });
  }
}

void _showSnackBar(BuildContext context, String message, bool showwatchme) {
  final snackBar = SnackBar(
    content: Text(message),
    action: SnackBarAction(
      label: 'Stop',
      onPressed: () async {
        final instance = await SharedPreferences.getInstance();
        await instance.setBool('canSendData', false);
        showwatchme = true;
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
