import 'dart:async';
import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/network/esp_wifi_provisioning.dart';
import 'package:train_dashboard_app/features/esp_connect/esp_connect_controller.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/status_button.dart';

enum EspConnect { connect, provide }

class EspConnectPage extends StatefulWidget {
  const EspConnectPage({super.key});

  @override
  State<EspConnectPage> createState() => _EspConnectPageState();
}

class _EspConnectPageState extends State<EspConnectPage> {
  late final EspConnectController _controller;
  EspConnect state = EspConnect.connect;

  @override
  void initState() {
    super.initState();
    _controller = EspConnectController();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ui(),
        ),
      ),
    );
  }

  List<Widget> ui() {
    if (state == EspConnect.connect) {
      return _connect();
    } else {
      return _provide();
    }
  }

  List<Widget> _connect() {
    return [
      _buildIcon(),
      const SizedBox(height: 32),
      _buildTitle("Connect to the train's access point"),
      const SizedBox(height: 64),
      StatusButton(
        label: "Begin",
        isLoading: _controller.isLoading,
        isError: _controller.isError,
        errorText: "Unable to connect!",
        onPressed: _checkConnection,
      ),
    ];
  }

  List<Widget> _provide() {
    return [
      _buildTitle("Provide the SSID and password"),
      const SizedBox(height: 32),
      _buildTextField("SSID", _controller.ssidController),
      const SizedBox(height: 16),
      _buildTextField("Password", _controller.passwordController, hiddenText: true),
      const SizedBox(height: 24),

      StatusButton(
        label: "Connect",
        isLoading: _controller.isLoading,
        isError: _controller.isError,
        errorText: "Provided wrong credentials to connect",
        onPressed: _tryConnect,
      ),
    ];
  }

  Widget _buildIcon() {
    return const Icon(Icons.wifi, size: 100);
  }

  Widget _buildTitle(String label) {
    return Text(
      label,
      style: TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool hiddenText = false}) {
    return TextField(
      controller: controller,
      obscureText: hiddenText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _tryConnect() async {
    final ok = await _controller.tryingCredentials();

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Connected successfully")));

      setState(() {
        state = EspConnect.provide;
      });
    }
  }

  Future<void> _checkConnection() async {
    await _controller.checkConnection();

    if (!mounted) return;

    if (_controller.state == EspConnectState.connected) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Connected successfully")));

      setState(() {
        state = EspConnect.provide;
      });
    }
  }
}
