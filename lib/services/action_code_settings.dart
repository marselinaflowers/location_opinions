import 'package:firebase_auth/firebase_auth.dart' show ActionCodeSettings;
class AuthActionCodeSettings {
  static String getUrlForHost(String host) {
    if (host.contains('firebaseapp.com')) {
      return 'https://location-topics.firebaseapp.com';
    } else if (host.contains('web.app')) {
      return 'https://location-topics.web.app';
    } else if (host.contains('locationemu.com')) {
      return 'https://locationemu.com';
    } else {
      return 'https://localhost';
    }
  }

  static ActionCodeSettings forHost(String host) {
    return ActionCodeSettings(
      url: getUrlForHost(host),
      handleCodeInApp: true,
    );
  }

  static ActionCodeSettings get settings => forHost(Uri.base.host);
}
