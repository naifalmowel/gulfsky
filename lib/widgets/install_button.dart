import 'dart:html' as html;
import 'package:js/js_util.dart' as js_util;
import 'package:flutter/material.dart';

class InstallAppButton extends StatefulWidget {
  const InstallAppButton({super.key});

  @override
  State<InstallAppButton> createState() => _InstallAppButtonState();
}

class _InstallAppButtonState extends State<InstallAppButton> {
  bool _canInstall = false;

  @override
  void initState() {
    super.initState();

    // Listen for the custom JS event when PWA is available
    html.window.addEventListener('pwaInstallAvailable', (event) {
      setState(() {
        _canInstall = true;
      });
    });
  }

  void _installApp() {
    js_util.callMethod(html.window, 'showInstallPrompt', []);
  }

  @override
  Widget build(BuildContext context) {
    if (!_canInstall) return const SizedBox.shrink();

    return ElevatedButton.icon(
      onPressed: _installApp,
      icon: const Icon(Icons.download),
      label: const Text('Install App'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
