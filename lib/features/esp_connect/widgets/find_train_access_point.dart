import 'package:flutter/material.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/access_point_list.dart';
import 'package:train_dashboard_app/features/esp_connect/wifi_scan_controller.dart';
import 'package:wifi_scan/wifi_scan.dart';

class FindTrainAccessPoint extends StatefulWidget {
  final String title;
  final Function(WiFiAccessPoint) onAccessPointTap;
  final String? filterName;

  const FindTrainAccessPoint({super.key, required this.title, required this.onAccessPointTap, this.filterName});

  @override
  State<FindTrainAccessPoint> createState() => _FindTrainAccessPointState();
}

class _FindTrainAccessPointState extends State<FindTrainAccessPoint> {
  late final WifiScanController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WifiScanController();
    _controller.scan();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller, 
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),

              _buildTitle(),

              Expanded(
                child: AccessPointList(
                  accessPoints: _controller.accessPoints,
                  onTap: (ap) => setState(() => widget.onAccessPointTap(ap)),
                ),
              ),

              _buildRefreshButton(),

              const SizedBox(height: 80),
            ]
          )
        );
      }
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildRefreshButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _controller.isScanning ? null : () {
          _controller.scan();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          "Refresh",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
