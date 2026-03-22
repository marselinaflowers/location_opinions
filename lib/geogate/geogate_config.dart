// This file defines the geofence for the app.
// Only users within the specified radius (in meters) of the center point can interact (post, vote, etc).
// Outside this area, the app is read-only.

class GeoGateConfig {
  // First permitted area
  static const double centerLat = 42.474280; 
  static const double centerLng = -83.791492;
  static const double radiusMeters = 500; // 500 meters

  // Second permitted area
  static const double centerLat2 = 42.225002; // 
  static const double centerLng2 = -83.62420;
  static const double radiusMeters2 = 390; // 390 meters
}
