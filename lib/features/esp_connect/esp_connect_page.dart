import 'dart:async';
import 'package:flutter/material.dart';
import 'package:train_dashboard_app/features/esp_connect/esp_connect_controller.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/access_point_card.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/network_permission.dart';
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

  List<WiFiAccessPoint> accessPoints = [];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;

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
    subscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: NetworkPermission(
          onPressed: () async {
            final can = await WiFiScan.instance.canGetScannedResults(
              askPermissions: true,
            );

            if (can == CanGetScannedResults.yes) {
              print("yey!");
            }
          },
        ),
      ),
    );
  }

  Widget ui() {
    switch (state) {
      case EspConnect.connect:
        return _connect();
      case EspConnect.provide:
        return _provide();
      case EspConnect.connected:
        return _connected();
    }
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

  Widget _provide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        _buildTitle("Provide the SSID and password"),
        const SizedBox(height: 16),

        Expanded(child: _buildAccessPointList(accessPoints)),

        const SizedBox(height: 16),
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

        _startListeningToScannedResults();
      });
    }
  }

  Future<void> _startListeningToScannedResults() async {
    final can = await WiFiScan.instance.canGetScannedResults(
      askPermissions: true,
    );

    switch (can) {
      case CanGetScannedResults.yes:
        await subscription?.cancel();

        subscription = WiFiScan.instance.onScannedResultsAvailable.listen((
          results,
        ) {
          if (!mounted) return;

          final Map<String, WiFiAccessPoint> unique = {};

          for (final ap in results) {
            if (ap.ssid.isEmpty) continue;

            final existing = unique[ap.ssid];

            if (existing == null || ap.level > existing.level) {
              unique[ap.ssid] = ap;
            }
          }

          setState(() {
            accessPoints = unique.values.toList()
              ..sort((a, b) => b.level.compareTo(a.level));
          });
        });
        break;

      case CanGetScannedResults.noLocationServiceDisabled:
      case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
      case CanGetScannedResults.noLocationPermissionDenied:
      case CanGetScannedResults.notSupported:
      case CanGetScannedResults.noLocationPermissionRequired:
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("WiFi scanning not available")),
        );
        break;
    }
  }
}
