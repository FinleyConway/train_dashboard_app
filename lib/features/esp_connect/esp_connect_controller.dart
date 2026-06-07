import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/network/esp_wifi_provisioning.dart';

class EspConnectController extends ChangeNotifier {
  bool isCheckingConnection = false;
  bool showError = false;

  Future<bool> checkConnection() async {
    if (isCheckingConnection) return false;

    isCheckingConnection = true;
    showError = false;
    
    notifyListeners();

    final ok = await EspWifiProvisioning.isConnectedToEspAP();

    isCheckingConnection = false;
    showError = !ok;

    notifyListeners();

    return ok;
  }
}