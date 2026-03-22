import 'package:flutter/material.dart';

class GeoGateBypassPage extends StatefulWidget {
  final void Function(String code) onSubmit;
  final bool invalidCode;
  const GeoGateBypassPage({super.key, required this.onSubmit, this.invalidCode = false});

  @override
  State<GeoGateBypassPage> createState() => _GeoGateBypassPageState();
}

class _GeoGateBypassPageState extends State<GeoGateBypassPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Bypass Code')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Bypass Code',
                  errorText: widget.invalidCode ? 'Invalid code' : null,
                ),
                onSubmitted: (val) => widget.onSubmit(val.trim()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => widget.onSubmit(_controller.text.trim()),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
