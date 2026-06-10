import 'package:flutter/material.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/access_point/access_point_list.dart';
import 'package:train_dashboard_app/features/esp_connect/controllers/wifi_controller.dart';

class FindAccessPoint extends StatefulWidget {
  final WifiController controller;
  final String title;
  final Function(String) onAccessPointTap;
  final String? filterName;

  const FindAccessPoint({super.key, required this.controller, required this.title, required this.onAccessPointTap, this.filterName});

  @override
  State<FindAccessPoint> createState() => _FindAccessPointState();
}

class _FindAccessPointState extends State<FindAccessPoint> {
  @override
  void initState() {
    super.initState();

    widget.controller.scan(filter: widget.filterName);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller, 
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),

              const SizedBox(height: 32),

              Expanded(
                child: AccessPointList(
                  accessPoints: widget.controller.accessPoints,
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
        onPressed: widget.controller.isScanning ? null : () {
          widget.controller.scan(filter: widget.filterName);
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
