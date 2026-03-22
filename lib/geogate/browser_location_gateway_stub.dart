import 'location_snapshot.dart';

Future<LocationSnapshot> getCurrentLocationFromBrowser({
  required bool requestPermission,
}) {
  throw UnsupportedError('Browser geolocation is only available on web.');
}