import 'dart:convert';
import 'package:http/http.dart' as http;

class EspWifiProvisioningService {
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

  static Future<bool> getWifiStatus({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse("http://192.168.4.1/wifi_cred/status"),
            headers: {"Accept": "application/json"},
          )
          .timeout(timeout);

      if (response.statusCode != 200) return false;

      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;

      return body["connected"] == true;
    } catch (_) {
      return false;
    }
  }
}
