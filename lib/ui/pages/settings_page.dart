import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../services/theme_color_service.dart';
import '../../services/auth_service.dart';
import 'link_email_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Color _pickerColor;
  final AuthService _authService = AuthService();
  String? _displayName;

  @override
  void initState() {
    super.initState();
    _pickerColor = ThemeColorService.instance.color;
    _displayName = _authService.username ?? 'Settings';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_displayName ?? 'Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Theme Color',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ColorPicker(
              pickerColor: _pickerColor,
              onColorChanged: (color) {
                setState(() => _pickerColor = color);
              },
              displayThumbColor: true,
              enableAlpha: false,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await ThemeColorService.instance.save(_pickerColor);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Color saved')),
                  );
                }
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 80),
            Center(
              child: TextButton(
                onPressed: () async {
                  // Show the link email page, then after success, prompt for username change
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LinkEmailPage()),
                  );
                  // Only show dialog if result is a map with change_username true
                  if (result is Map && result['change_username'] == true && context.mounted) {
                    final previousUsername = result['previous_username'] as String? ?? '';
                    final controller = TextEditingController();
                    final newName = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Change Username'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Previous username: $previousUsername'),
                              const SizedBox(height: 12),
                              TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  labelText: 'New Username',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(controller.text.trim()),
                              child: const Text('Change'),
                            ),
                          ],
                        );
                      },
                    );
                    if (newName != null && newName.isNotEmpty) {
                      final error = await _authService.signInWithUsername(newName);
                      if (context.mounted) {
                        if (error == null) {
                          setState(() => _displayName = newName);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Username changed!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        }
                      }
                    }
                  }
                },
                child: const Text('register email to change username'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
