import 'dart:convert';

import 'package:http/http.dart';
import 'package:routesapp/backend/Locationservice.dart';
import 'package:routesapp/utils.dart';

class IndagerService {
  static getIndangerPeople() async {
    try {
      final indangerpeople =
          await get(Uri(host: "${HOST}/dangers", port: 8080));
      print(indangerpeople);
      return indangerpeople;
    } catch (e) {
      print(e);
    }
  }

  static sendDanger() async {
    try {
      final location = await LocationService().getLocation();
      await post(Uri(host: "localhost", port: 8080), body: {
        json.encode(
            {"longitude": location?.longitude, "latitude": location?.latitude})
      });
    } catch (e) {
      print(e);
    }
  }
}
