import 'package:flutter/material.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/connect_to_network.dart';
import 'package:train_dashboard_app/features/esp_connect/widgets/connecting_to_network.dart';

class ConnectionFlow extends StatefulWidget {
  final String? ssid;

  const ConnectionFlow({super.key, this.ssid});
  
    @override
    State<ConnectionFlow> createState() => _ConnectionFlowState();
}

class _ConnectionFlowState extends State<ConnectionFlow> {
  bool _isConnecting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isConnecting
          ? ConnectingToNetwork()
          : ConnectToNetwork(
              ssid: widget.ssid,
              onTryConnect: _onTryConnect,
            ),
    );
  }

  void _onTryConnect(String ssid, String password) {
    setState(() => _isConnecting = true);
    
  }
}