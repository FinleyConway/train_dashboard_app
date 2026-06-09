import 'dart:async';

import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/network/esp_wifi_provisioning.dart';

class EspConnectController extends ChangeNotifier {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  EspConnectState get state => _state;
  bool get isSuccess => _state == EspConnectState.connected;
  bool get isLoading => _state == EspConnectState.connecting;
  bool get isError =>
    _state == EspConnectState.fail ||
    _state == EspConnectState.badCredentials ||
    _state == EspConnectState.timeout;

  EspConnectState _state = EspConnectState.idle;
  final _maxAttempts = 10;
  final _frequency = const Duration(seconds: 1);

  @override
  void dispose() {
    ssidController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> checkConnection() async {
    if (isLoading) return false;

    final ok = await EspWifiProvisioning.isConnectedToEspAP();

    _setState(ok ? EspConnectState.connected : EspConnectState.fail);

    return ok;
  }

  Future<bool> tryingCredentials() async {
    if (isLoading) return false;

    _setState(EspConnectState.connecting);

    final ssid = ssidController.text;
    final password = passwordController.text;

    if (ssid.isEmpty) {
      _setState(EspConnectState.badCredentials);

      return false;
    }

    final ok = await EspWifiProvisioning.connectToWifi(ssid, password);

    if (!ok) {
      _setState(EspConnectState.lostConnection);

      return false;
    }

    return await _pollStatus();
  }

  Future<bool> _pollStatus() async {
    for (int i = 0; i < _maxAttempts; i++) {
      final status = await EspWifiProvisioning.getWifiStatus();

      _setState(status);

      if (status == EspConnectState.connected) {
        return true;
      }

      if (status == EspConnectState.badCredentials) {
        return false; 
      }

      await Future.delayed(_frequency);
    }

    _setState(EspConnectState.timeout);

    return false;
  }


  void _setState(EspConnectState newState) {
    _state = newState;
    notifyListeners();
  }
}