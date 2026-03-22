// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'location_snapshot.dart';

Future<LocationSnapshot> getCurrentLocationFromBrowser({
  required bool requestPermission,
}) async {
  if (!requestPermission) {
    throw Exception('Tap "Check location again" to grant location access.');
  }

  final geolocation = html.window.navigator.geolocation;

  html.Geoposition position;
  try {
    position = await geolocation.getCurrentPosition(
      enableHighAccuracy: true,
      timeout: const Duration(seconds: 15),
      maximumAge: Duration.zero,
    );
  } catch (error) {
    final dynamic code = (error as dynamic).code;
    if (code == 1) {
      throw Exception('Location permission was denied.');
    }
    if (code == 2) {
      throw Exception('Location information is unavailable.');
    }
    if (code == 3) {
      throw Exception('Location request timed out.');
    }
    throw Exception('Unable to determine location.');
  }

  final coords = position.coords;
  if (coords == null) {
    throw Exception('Location coordinates are unavailable.');
  }
  final latitude = coords.latitude;
  final longitude = coords.longitude;
  if (latitude == null || longitude == null) {
    throw Exception('Location coordinates are unavailable.');
  }

  return LocationSnapshot(
    latitude: latitude.toDouble(),
    longitude: longitude.toDouble(),
    accuracyMeters: coords.accuracy?.toDouble(),
    timestamp: DateTime.fromMillisecondsSinceEpoch(position.timestamp?.toInt() ?? DateTime.now().millisecondsSinceEpoch),
  );
}