import 'models/opinion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/theme_color_service.dart';

import 'ui/pages/auth_page.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/opinion_creation_page.dart';
import 'ui/pages/opinion_comments_page.dart';
import 'ui/pages/geogate_bypass_page.dart';
import 'geogate/geo_access_service.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ThemeColorService.instance.load();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: ThemeColorService.instance.colorNotifier,
      builder: (context, color, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: color,
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case '/':
                builder = (_) => const AuthGate(); break;
              case '/home':
                builder = (_) => HomePage(); break;
              case '/create':
                builder = (_) => const OpinionCreationPage(); break;
              case '/comments':
                final opinion = settings.arguments as Opinion;
                builder = (_) => OpinionCommentsPage(opinion); break;
              default:
                return null;
            }
            return MaterialPageRoute(
              builder: (context) => GeoGateRouteGuard(childBuilder: builder),
              settings: settings,
            );
          },
        );
      },
    );
  }
}

/// Widget that checks geogate before showing the child route.
class GeoGateRouteGuard extends StatefulWidget {
  final WidgetBuilder childBuilder;
  const GeoGateRouteGuard({required this.childBuilder, super.key});

  @override
  State<GeoGateRouteGuard> createState() => _GeoGateRouteGuardState();
}

class _GeoGateRouteGuardState extends State<GeoGateRouteGuard> {
  bool? _allowed;
  bool _bypassActive = false;
  bool _bypassInvalid = false;
  final GeoAccessService _geoAccessService = GeoAccessService();

  @override
  void initState() {
    super.initState();
    _checkGeo();
  }

  Future<void> _checkGeo() async {
    final decision = await _geoAccessService.evaluateAccess();
    setState(() {
      _allowed = decision.isAllowed;
    });
  }

  void _tryBypass(String code) {
    if (_geoAccessService.isValidBypassCode(code)) {
      setState(() {
        _allowed = true;
        _bypassActive = false;
        _bypassInvalid = false;
      });
    } else {
      setState(() {
        _bypassInvalid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_allowed == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_allowed! && !_bypassActive) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('This app is only available in a specific area.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => setState(() => _bypassActive = true),
                child: const Text('Enter Bypass Code'),
              ),
            ],
          ),
        ),
      );
    }
    if (_bypassActive) {
      return GeoGateBypassPage(
        onSubmit: _tryBypass,
        invalidCode: _bypassInvalid,
      );
    }
    // Normal route
    return widget.childBuilder(context);
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          return const AuthPage();
        }
        return HomePage();
      },
    );
  }
}