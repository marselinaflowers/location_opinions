import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'theme_color';
const _defaultColor = 0xFF800000; // maroon

class ThemeColorService {
  ThemeColorService._();
  static final instance = ThemeColorService._();

  final ValueNotifier<Color> colorNotifier = ValueNotifier(Color(_defaultColor));

  Color get color => colorNotifier.value;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_key);
    if (value != null) {
      colorNotifier.value = Color(value);
    }
  }

  Future<void> save(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, color.toARGB32());
    colorNotifier.value = color;
  }
}

