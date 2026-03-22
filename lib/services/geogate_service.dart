// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import '../geogate/geogate_config.dart';

// class GeoGateService {
//   static Future<bool> isWithinGate() async {
//     Location location = Location();
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//     LocationData locationData;

//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return false;
//       }
//     }

//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//     }
//     if (permissionGranted != PermissionStatus.granted) {
//       // If deniedForever or still denied, cannot proceed
//       return false;
//     }

//     locationData = await location.getLocation();
//     double? lat = locationData.latitude;
//     double? lng = locationData.longitude;
//     if (lat == null || lng == null) return false;
//     return _isWithinRadius(lat, lng, GeoGateConfig.centerLat, GeoGateConfig.centerLng, GeoGateConfig.radiusMeters);
//   }

//   static bool _isWithinRadius(double lat1, double lng1, double lat2, double lng2, double radiusMeters) {
//     const double earthRadius = 6371000; // meters
//     double dLat = _deg2rad(lat2 - lat1);
//     double dLng = _deg2rad(lng2 - lng1);
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
//             sin(dLng / 2) * sin(dLng / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     double distance = earthRadius * c;
//     return distance <= radiusMeters;
//   }

//   static double _deg2rad(double deg) => deg * (pi / 180.0);
// }
