import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiController extends ChangeNotifier {
  List<WiFiAccessPoint> get accessPoints => _accessPoints;
  bool get isScanning => _isScanning;

  List<WiFiAccessPoint> _accessPoints = [];
  bool _isScanning = false;
  final WiFiScan _wifi = WiFiScan.instance;

  Future<bool> hasScanningPermissions({bool ask = true}) async {
    final can = await WiFiScan.instance.canStartScan(askPermissions: ask);

    return can == CanStartScan.yes;
  }

  Future<void> scan({String? filter}) async {
    if (!await hasScanningPermissions()) return;

    _isScanning = true;
    _accessPoints.clear();

    notifyListeners();

    await _wifi.startScan();

    final results = await _wifi.getScannedResults();

    Set<String> seen = {};
    final cleanResults = results.where((ap) {
      if (ap.ssid.isEmpty) return false;

      return seen.add(ap.ssid);
    }).toList();

    _accessPoints = filter == null
        ? cleanResults
        : cleanResults.where((ap) => !ap.ssid.contains(filter)).toList();

    _isScanning = false;

    notifyListeners();
  }

  void openWifiSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.wifi);
  }
}
