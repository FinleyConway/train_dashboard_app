import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum EspConnectState {
  fail,
  idle,
  connected,
  connecting,
  badCredentials
}

class EspWifiProvisioning {
  static Future<bool> isConnectedToEspAP({
    Duration timeout = const Duration(seconds: 2),
  }) async {
    try {
      final response = await http
          .get(Uri.parse("http://192.168.4.1/ping"))
          .timeout(timeout);

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> connectToWifi(
    String ssid,
    String password, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      final body = jsonEncode({"ssid": ssid, "password": password});

      final response = await http
          .post(
            Uri.parse("http://192.168.4.1/wifi_cred/connect"),
            headers: {"Content-Type": "application/json"},
            body: body,
          )
          .timeout(timeout);

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<EspConnectState> getWifiStatus({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse("http://192.168.4.1/wifi_cred/status"),
            headers: {"Accept": "application/json"},
          )
          .timeout(timeout);

      if (response.statusCode != 200) return EspConnectState.fail;

      return _getWifiState(jsonDecode(response.body));
    } catch (_) {
      return EspConnectState.fail;
    }
  }

  static EspConnectState _getWifiState(dynamic body) {
    switch (body["status"]) {
      case "connected":
        return EspConnectState.connected;

      case "connecting":
        return EspConnectState.connecting;

      case "bad_credentials":
        return EspConnectState.badCredentials;

      case "idle":
        return EspConnectState.idle;

      default:
        return EspConnectState.fail;
    }
  }
}
