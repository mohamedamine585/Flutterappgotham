import 'package:flutter/material.dart';
import 'package:routesapp/backend/Indanger.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
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
                    child: Container(
                      width: 350,
                      height: 150,
                      child: Positioned.fill(
                        child: Image.asset(
                          "assets/batman.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: RawMaterialButton(
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
                      onPressed: () async {
                        Navigator.of(context).pushNamed("mappage", arguments: [
                          "local",
                          [50, 100]
                        ]);
                      },
                      elevation: 2.0,
                      fillColor: Colors.red,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(50.0),
                    ),
                  ),
                ],
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
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) {
                  return Color.fromARGB(255, 176, 6, 6);
                })),
              ),
              SizedBox(
                height: 10,
              ),
            ]),
          ),
        ));
  }
}
