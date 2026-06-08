import 'package:flutter/material.dart';

class WifiSignalIcon extends StatelessWidget {
  final int level;
  final double size;

  const WifiSignalIcon({super.key, required this.level, this.size = 24});

  @override
  Widget build(BuildContext context) {
    // https://pub.dev/documentation/wifi_scan/latest/wifi_scan/WiFiAccessPoint/level.html
    
    if (level >= -30) {
      return Icon(Icons.wifi, size: size); // excellent
    } else if (level >= -67) {
      return Icon(Icons.wifi_2_bar, size: size); // very good
    } else if (level >= -70) {
      return Icon(Icons.wifi_2_bar, size: size); // okay
    } else if (level >= -80) {
      return Icon(Icons.wifi_1_bar, size: size); // not good
    } else if (level >= -90) {
      return Icon(Icons.wifi_1_bar, size: size); // unusable
    } else {
      return Icon(Icons.wifi_off, size: size); // no connection
    }
  }
}
