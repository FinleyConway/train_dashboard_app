import 'package:flutter/material.dart';
import 'package:train_dashboard_app/features/esp_connect/controllers/esp_connect_controller.dart';
import 'package:train_dashboard_app/features/esp_connect/controllers/wifi_controller.dart';
import 'package:train_dashboard_app/features/widgets/status_button.dart';

class DirectWifiMenu extends StatelessWidget {
  final WifiController wifiController;
  final EspConnectController espController;
  final VoidCallback onPressed;

  const DirectWifiMenu({
    super.key,
    required this.wifiController,
    required this.espController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: espController,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),

              _buildWifiIcon(),

              const SizedBox(height: 16),

              _buildText(),

              const SizedBox(height: 16),

              _buildContextText(),

              const Spacer(),

              _buildButton("Go to WiFi settings", _onWiFiSettings),

              const SizedBox(height: 8),

              StatusButton(
                label: "Check connection",
                isLoading: espController.isLoading,
                onPressed: _onCheckConnection,
              ),

              if (espController.isError) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.error_outline, size: 16, color: Colors.red),
                    const SizedBox(width: 6),
                    const Text(
                      "Not connected to train!",
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWifiIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.wifi, color: Colors.blue.shade700, size: 32),
    );
  }

  Widget _buildText() {
    return const Text(
      "Find the train's access point",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContextText() {
    return const Text(
      "When returned, click check connection to connect to the train",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButton(String label, VoidCallback callback) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _onWiFiSettings() {
    wifiController.openWifiSettings();
  }

  void _onCheckConnection() async {
    bool connected = await espController.checkConnection();

    if (connected) {
      onPressed.call();
    }
  }
}
