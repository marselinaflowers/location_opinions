// import 'package:geolocator/geolocator.dart';
// import '../geogate/geogate_config.dart';
// import 'dart:math' as math;

// class GeoGate {
//   static bool _bypass = false;

//   static void setBypass(bool value) {
//     _bypass = value;
//   }

//   // Returns true if the user is inside any permitted geofence, false otherwise.
//   static Future<bool> isInsideGate() async {
//     if (_bypass) return true;
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return false;
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return false;
//     }
//     if (permission == LocationPermission.deniedForever) return false;
//     Position pos = await Geolocator.getCurrentPosition();
//     return isPointInsideAnyGate(pos.latitude, pos.longitude);
//   }

//   // Returns true if the given lat/lng is inside any permitted area.
//   static bool isPointInsideAnyGate(double lat, double lng) {
//     // First area
//     if (_isWithinRadius(
//       lat,
//       lng,
//       GeoGateConfig.centerLat,
//       GeoGateConfig.centerLng,
//       GeoGateConfig.radiusMeters,
//     )) {
//       return true;
//     }
//     // Second area
//     if (_isWithinRadius(
//       lat,
//       lng,
//       GeoGateConfig.centerLat2,
//       GeoGateConfig.centerLng2,
//       GeoGateConfig.radiusMeters2,
//     )) {
//       return true;
//     }
//     return false;
//   }

//   // Haversine formula for distance between two lat/lng points in meters
//   static bool _isWithinRadius(double lat1, double lng1, double lat2, double lng2, double radiusMeters) {
//     const earthRadius = 6371000.0; // meters
//     final dLat = _deg2rad(lat2 - lat1);
//     final dLng = _deg2rad(lng2 - lng1);
//     final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//         math.cos(_deg2rad(lat1)) * math.cos(_deg2rad(lat2)) *
//         math.sin(dLng / 2) * math.sin(dLng / 2);
//     final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//     final distance = earthRadius * c;
//     return distance <= radiusMeters;
//   }

//   static double _deg2rad(double deg) => deg * math.pi / 180.0;
// }
