import 'dart:convert';

import 'package:http/http.dart' as http;

class TrainMotorControl {
  static Future<bool> control(
    int trainId,
    int currentDuty,
    int targetDuty,
    bool active,
  ) async {
    final int rampTimeMs = 0;

    try {
      final body = jsonEncode({
        "train_id": trainId,
        "is_active": active,
        "starting_duty": currentDuty,
        "target_duty": targetDuty,
        "ramp_time_ms": rampTimeMs,
      });

      final response = await http.post(
        Uri.parse("http://esp-api.local:8000/api/motor_control"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
