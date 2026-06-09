import 'package:flutter/material.dart';
import 'package:train_dashboard_app/features/esp_connect/controllers/esp_connect_controller.dart';
import 'package:train_dashboard_app/features/esp_connect/controllers/wifi_controller.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/connect_to_network.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/connecting_to_network.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/find_access_point.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/network_permission.dart';
import 'package:train_dashboard_app/features/widgets/app_header.dart';

enum EspConnectState {
  permissionCheck,
  findAccessPoint,
  selectNetwork,
  connecting,
  connected,
}

class EspConnectPage extends StatefulWidget {
  const EspConnectPage({super.key});

  @override
  State<EspConnectPage> createState() => _EspConnectPageState();
}

class _EspConnectPageState extends State<EspConnectPage> {
  late final EspConnectController _espController;
  late final WifiController _wifiController;

  EspConnectState _state = EspConnectState.permissionCheck;
  String? _selectedSsid;

  @override
  void initState() {
    super.initState();

    _espController = EspConnectController();
    _wifiController = WifiController();

    _checkPermissions();
  }

  @override
  void dispose() {
    _espController.dispose();
    _wifiController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: "Setup Train"),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(
          key: ValueKey(_state),
          child: _buildState(),
        ),
      ),
    );
  }

  Widget _buildState() {
    switch (_state) {
      case EspConnectState.permissionCheck:
        return NetworkPermission(
          onPressed: () {
              setState(() => _state = EspConnectState.findAccessPoint);
          }
        );

      case EspConnectState.findAccessPoint:
        return FindAccessPoint(
          title: "Select a train",
          onAccessPointTap: (String ssid) {
              setState(() => _state = EspConnectState.selectNetwork);
          },
          filterName: "esp_device", // make a config class later?
        );

      case EspConnectState.selectNetwork:
        return ConnectToNetwork(
          ssid: _selectedSsid!,
          onTryConnect: (String ssid, String password) { 
            setState(() => _state = EspConnectState.connecting);
          },
        );

      case EspConnectState.connecting:
        return ConnectingToNetwork();

      case EspConnectState.connected:
        return const Center(child: Text('Connected'));
    }
  }

  Future<void> _checkPermissions() async {
    final hasPermission = await _wifiController.hasScanningPermissions(
      ask: false,
    );

    if (!mounted) return;

    setState(() {
      _state = hasPermission
          ? EspConnectState.findAccessPoint
          : EspConnectState.permissionCheck;
    });
  }
}
