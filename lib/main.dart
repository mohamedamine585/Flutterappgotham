import 'package:flutter/material.dart';
import 'package:routesapp/HomePage.dart';
import 'package:routesapp/map_screen.dart';

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
    routes: {"mappage": (context) => MapScreen()},
  ));
}
