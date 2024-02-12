import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:routesapp/HomePage.dart';
import 'package:routesapp/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "flutter_background example app",
    notificationText:
        "Background notification for keeping the example app running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(
        name: 'background_icon',
        defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  bool success =
      await FlutterBackground.initialize(androidConfig: androidConfig);
  runApp(MaterialApp(
    routes: {"mappage": (context) => const MapScreen()},
    home: MyHomePage(),
  ));
}
