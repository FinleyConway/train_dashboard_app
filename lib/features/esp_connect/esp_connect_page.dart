import 'dart:async';
import 'package:flutter/material.dart';
import 'package:train_dashboard_app/features/esp_connect/esp_connect_controller.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/access_point_card.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/find_access_point.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/status_button.dart';
import 'package:wifi_scan/wifi_scan.dart';

enum EspConnect { connect, provide, connected }

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
      if (!mounted) return;
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
      body: Center(
        child: FindAccessPoint(
          title: "Find train access point",
          onAccessPointTap: (ap) {
            print(ap.ssid);
          },
        )
      ),
    );
  }

  Widget _connect() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi, size: 100),
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
      ],
    );
  }

  Widget _connected() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.check, size: 100),
        SizedBox(height: 16),
        Text(
          "Train is connected to the network!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildTitle(String label) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20),
    );
  }

  Widget _buildAccessPointList(List<WiFiAccessPoint> aps) {
    final filtered = aps.where((ap) => ap.ssid.isNotEmpty).toList()
      ..sort((a, b) => b.level.compareTo(a.level));

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final ap = filtered[index];

        //final isSelected = selectedAp?.ssid == ap.ssid;

        return AccessPointCard(
          level: ap.level,
          ssid: ap.ssid,
          isOpen: !ap.capabilities.toUpperCase().contains('WPA'),
          onTap: () {
            //setState(() => selectedAp = ap);
            print(ap.ssid);
          },
        );
      },
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
        state = EspConnect.connected;
      });
    }
  }

  Future<void> _checkConnection() async {
    final ok = await _controller.checkConnection();

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
}
