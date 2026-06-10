import 'package:flutter/material.dart';
import 'package:train_dashboard_app/features/esp_connect/controllers/esp_connect_controller.dart';
import 'package:train_dashboard_app/features/esp_connect/controllers/wifi_controller.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/connect_to_network.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/connecting_to_network.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/direct_wifi_menu.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/find_access_point.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/network_permission.dart';
import 'package:train_dashboard_app/features/widgets/app_header.dart';

enum EspConnectState {
  permissionCheck,
  findTrainAccessPoint,
  findWifiAccessPoint,
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
  EspConnectState? _previousState; 

  bool _hasPermission = false;
  String? _selectedTrainSsid;
  String? _selectedNetworkSsid;

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
      appBar: AppHeader(
        title: "Setup Train",
        onBack: _goBack,
      ),
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
        // just move on to the next state if perms are set
        if (_hasPermission) {
          setState(() => _state = EspConnectState.findTrainAccessPoint);
        }

        return NetworkPermission(
          controller: _wifiController,
          onPressed: () async {
            setState(() {
                _state = EspConnectState.findTrainAccessPoint;
            });
          }
        );

      case EspConnectState.findTrainAccessPoint:
        return DirectWifiMenu(
          wifiController: _wifiController,
          espController: _espController,
          onPressed: () {
              setState(() { 
                _previousState = _state;
                _state = EspConnectState.findWifiAccessPoint;
              });
          },
        );

      case EspConnectState.findWifiAccessPoint:
        return FindAccessPoint(
          controller: _wifiController,
          title: "Select a WiFi network",
          onAccessPointTap: (String ssid) {
              _selectedNetworkSsid = ssid;

              setState(() { 
                _previousState = _state;
                _state = EspConnectState.selectNetwork;
              });
          },
          filterName: "esp_device",
        );

      case EspConnectState.selectNetwork:
        return ConnectToNetwork(
          ssid: _selectedNetworkSsid!,
          onTryConnect: (String ssid, String password) { 
            setState(() {
              _previousState = null;
              _state = EspConnectState.connecting;
            });
          },
        );

      case EspConnectState.connecting:
        return ConnectingToNetwork();

      case EspConnectState.connected:
        return const Center(child: Text('Connected'));
    }
  }

  void _goBack() {
    if (_previousState == null) return;

    setState(() {
      _state = _previousState!;
    });
  }

  Future<void> _checkPermissions() async {
    _hasPermission = await _wifiController.hasScanningPermissions(
      ask: false,
    );

    if (!mounted) return;

    setState(() {
      _state = _hasPermission
          ? EspConnectState.findTrainAccessPoint
          : EspConnectState.permissionCheck;
    });
  }
}
