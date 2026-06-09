import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/access_point/access_point_card.dart';

class AccessPointList extends StatelessWidget {
  final List<WiFiAccessPoint> accessPoints;
  final void Function(String)? onTap;

  const AccessPointList({super.key, required this.accessPoints, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (accessPoints.isEmpty) {
      return const Center(child: Text("No access points found"));
    }

    return ListView.builder(
      itemCount: accessPoints.length,
      itemBuilder: (context, index) {
        final ap = accessPoints[index];

        return AccessPointCard(
          level: ap.level, 
          ssid: ap.ssid, 
          isOpen: ap.capabilities.contains('WPA') == false,
          onTap: () => onTap?.call(ap.ssid),
        );
      }
    );
  }
}