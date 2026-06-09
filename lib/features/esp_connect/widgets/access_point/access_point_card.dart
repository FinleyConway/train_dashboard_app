import 'package:flutter/material.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/access_point/wifi_signal_icon.dart';

class AccessPointCard extends StatelessWidget {
  final int level;
  final String ssid;
  final bool isOpen;
  final VoidCallback? onTap;

  const AccessPointCard({
    super.key,
    required this.level,
    required this.ssid,
    required this.isOpen,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, 
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              WifiSignalIcon(level: level),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  ssid,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              if (!isOpen) ...[
                const SizedBox(width: 8),
                const Icon(Icons.lock_outline, size: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
