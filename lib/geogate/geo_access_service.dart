import 'package:geolocator/geolocator.dart';

import 'location_snapshot.dart';
import 'browser_location_service.dart';

class GeoAccessDecision {
  final bool isAllowed;
  final LocationSnapshot? location;
  final double? distanceMeters;
  final String? reason;

  const GeoAccessDecision({
    required this.isAllowed,
    this.location,
    this.distanceMeters,
    this.reason,
  });
}

class GeoAccessService {
  static const double allowedCenterLatitude = 42.463056;
  static const double allowedCenterLongitude = -83.848056;
  static const double allowedRadiusMeters = 7000;
  static const String bypassCode = 'paradox';

  final BrowserLocationService _locationService = BrowserLocationService();

  Future<GeoAccessDecision> evaluateAccess({
    bool requestPermission = true,
  }) async {
    try {
      final location = await _locationService.getCurrentLocation(
        requestPermission: requestPermission,
      );
      final distanceMeters = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        allowedCenterLatitude,
        allowedCenterLongitude,
      );

      final isAllowed = distanceMeters <= allowedRadiusMeters;
      if (isAllowed) {
        return GeoAccessDecision(
          isAllowed: true,
          location: location,
          distanceMeters: distanceMeters,
        );
      }

      return GeoAccessDecision(
        isAllowed: false,
        location: location,
        distanceMeters: distanceMeters,
        reason: 'Outside Hamburg Township, Michigan.',
      );
    } catch (error) {
      return GeoAccessDecision(
        isAllowed: false,
        reason: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  bool isValidBypassCode(String code) {
    return code.trim().toLowerCase() == bypassCode;
  }
}
