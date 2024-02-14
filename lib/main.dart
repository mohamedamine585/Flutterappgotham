import 'dart:async';

import 'package:flutter/material.dart';

import 'package:routesapp/HomePage.dart';
import 'package:routesapp/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    routes: {"mappage": (context) => const MapScreen()},
    home: MyHomePage(),
  ));
}
