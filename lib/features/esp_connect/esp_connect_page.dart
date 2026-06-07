import 'dart:async';
import 'package:flutter/material.dart';
import 'package:train_dashboard_app/features/esp_connect/esp_connect_controller.dart';

class EspConnectPage extends StatefulWidget {
  const EspConnectPage({super.key});

  @override
  State<EspConnectPage> createState() => _EspConnectPageState();
}

class _EspConnectPageState extends State<EspConnectPage> {
  late final EspConnectController controller;

  @override
  void initState() {
    super.initState();
    controller = EspConnectController();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(),
              const SizedBox(height: 32),
              _buildTitle(),
              const SizedBox(height: 64),
              _buildButton(),
              const SizedBox(height: 24),
              _buildStatus(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return const Icon(Icons.wifi, size: 100);
  }

  Widget _buildTitle() {
    return const Text(
      "Connect to the train's access point",
      style: TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isCheckingConnection
            ? null
            : _checkConnection,

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA20021),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),

        child: const Text(
          "Begin",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildStatus() {
    return SizedBox(
      height: 40,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),

          child: controller.isCheckingConnection
              ? const SizedBox(
                  key: ValueKey("loading"),
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              : controller.showError
                  ? const Text(
                      "Unable to connect!",
                      key: ValueKey("error"),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    )
                  : const SizedBox.shrink(
                      key: ValueKey("empty"),
                    ),
        ),
      ),
    );
  }

  Future<void> _checkConnection() async {
    final ok = await controller.checkConnection();

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connected successfully")),
      );

      // navigate to nex connect section
    }
  }
}
