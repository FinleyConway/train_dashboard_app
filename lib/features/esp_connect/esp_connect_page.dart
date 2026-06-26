import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/utils/esp_wifi_provisioning.dart';
import 'package:train_dashboard_app/features/esp_connect/controllers/esp_connect_controller.dart';
import 'package:train_dashboard_app/features/esp_connect/controllers/wifi_controller.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/connect_to_network.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/connecting_to_network.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/direct_wifi_menu.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/find_access_point.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/network_permission.dart';
import 'package:train_dashboard_app/features/widgets/app_header.dart';

enum EspConnectPageState {
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

  EspConnectPageState _state = EspConnectPageState.permissionCheck;
  EspConnectPageState? _previousState;

  bool _hasPermission = false;
  String? _selectedNetworkSsid;
  String? _connectionError;

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
      appBar: AppHeader(title: "Setup Train", onBack: _goBack),
      body: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: KeyedSubtree(
              key: ValueKey(_state),
              child: _buildState(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildState() {
    switch (_state) {
      case EspConnectPageState.permissionCheck:
        // just move on to the next state if perms are set
        if (_hasPermission) {
          setState(() => _state = EspConnectPageState.findTrainAccessPoint);
        }

        return NetworkPermission(
          controller: _wifiController,
          onPressed: () async {
            setState(() {
              _state = EspConnectPageState.findTrainAccessPoint;
            });
          },
        );

      case EspConnectPageState.findTrainAccessPoint:
        return DirectWifiMenu(
          wifiController: _wifiController,
          espController: _espController,
          onPressed: () {
            setState(() {
              _previousState = _state;
              _state = EspConnectPageState.findWifiAccessPoint;
            });
          },
        );

      case EspConnectPageState.findWifiAccessPoint:
        return FindAccessPoint(
          controller: _wifiController,
          title: "Select a WiFi network",
          onAccessPointTap: (String ssid) {
            _selectedNetworkSsid = ssid;

            setState(() {
              _previousState = _state;
              _state = EspConnectPageState.selectNetwork;
            });
          },
          filterName: "esp_device",
        );

      case EspConnectPageState.selectNetwork:
        return ConnectToNetwork(
          ssid: _selectedNetworkSsid!,
          errorMessage: _connectionError,
          onTryConnect: (String ssid, String password) {
            setState(() {
              _state = EspConnectPageState.connecting;
              _connectionError = null;
            });

            _espController.tryCredentials(ssid, password).then((ok) {
              if (!mounted) return;

              if (ok) {
                setState(() => _state = EspConnectPageState.connected);
              } else {
                setState(() {
                  _state = EspConnectPageState.selectNetwork;

                  _parseConnectionError();
                });
              }
            });
          },
        );

      case EspConnectPageState.connecting:
        return ConnectingToNetwork();

      case EspConnectPageState.connected:
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
    _hasPermission = await _wifiController.hasScanningPermissions(ask: false);

    if (!mounted) return;

    setState(() {
      _state = _hasPermission
          ? EspConnectPageState.findTrainAccessPoint
          : EspConnectPageState.permissionCheck;
    });
  }

  void _parseConnectionError() {
    _connectionError = switch (_espController.state) {
      EspConnectState.badCredentials => "Incorrect credentials, try again!",
      EspConnectState.timeout => "Connection timed out!",
      _ => "",
    };
  }
}
