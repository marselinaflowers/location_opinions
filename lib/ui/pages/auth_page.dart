import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _usernameController = TextEditingController();
  String? _errorText;
  bool _isSubmitting = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final entered = _usernameController.text.trim();

    setState(() {
      _errorText = null;
    });

    if (entered.isEmpty || entered.length > 30 || entered.length < 3) {
      final suggestedUsername = await _showSuggestedUsernameDialog();
      if (suggestedUsername != null) {
        _usernameController.text = suggestedUsername;
        _usernameController.selection = TextSelection.collapsed(
          offset: _usernameController.text.length,
        );
        await _signInWithUsername(suggestedUsername);
      }
      return;
    }

    await _signInWithUsername(entered);
  }

  Future<void> _signInWithUsername(String username) async {
    setState(() {
      _errorText = null;
      _isSubmitting = true;
    });

    final error = await _authService.signInWithUsername(username);
    if (mounted) {
      setState(() {
        _errorText = error;
        _isSubmitting = false;
      });
    }
  }

  String _generateSuggestedUsername() {
    return _authService.generateSuggestedUsername();
  }

  Future<String?> _showSuggestedUsernameDialog() async {
    var suggestedUsername = _generateSuggestedUsername();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Suggested username'),
              content: Text(suggestedUsername, textAlign: TextAlign.right,),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      suggestedUsername = _generateSuggestedUsername();
                    });
                  },
                  child: const Text('Change name'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop(suggestedUsername);
                  },
                  child: const Text('Continue'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose username')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  textAlign: TextAlign.right,
                  controller: _usernameController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter a username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Continue'),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
