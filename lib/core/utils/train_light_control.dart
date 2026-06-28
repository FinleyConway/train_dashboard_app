import 'dart:convert';

import 'package:http/http.dart' as http;

class TrainLightControl {
  static Future<bool> control(int trainId, int brightness, bool active) async {
    try {
      final body = jsonEncode({
        "train_id": trainId,
        "brightness": brightness,
        "is_active": active,
      });

      final response = await http.post(
        Uri.parse("http://esp-api.local:8000/api/headlight_control"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
