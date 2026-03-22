import 'package:flutter/foundation.dart';

import 'location_snapshot.dart';
import 'browser_location_gateway_stub.dart'
    if (dart.library.html) 'browser_location_gateway_web.dart';

class BrowserLocationService {
  Future<LocationSnapshot> getCurrentLocation({
    bool requestPermission = true,
  }) async {
    if (!kIsWeb) {
      throw UnsupportedError(
        'Geolocation is currently enabled only for web builds.',
      );
    }

    final position = await getCurrentLocationFromBrowser(
      requestPermission: requestPermission,
    );
    return position;
  }
}
