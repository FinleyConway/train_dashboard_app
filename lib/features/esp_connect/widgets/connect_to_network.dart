import 'package:flutter/material.dart';

class ConnectToNetwork extends StatefulWidget {
  final String? ssid;
  final Function(String, String) onTryConnect;

  const ConnectToNetwork({super.key, required this.onTryConnect, this.ssid});

  @override
  State<ConnectToNetwork> createState() => _ConnectToNetworkState();
}

class _ConnectToNetworkState extends State<ConnectToNetwork> {
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
     _ssidController.dispose();
     _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),

          const SizedBox(height: 24),

          TextField(
            readOnly: widget.ssid != null,
            controller: widget.ssid == null
              ? _ssidController
              : TextEditingController(text: widget.ssid),
            decoration: const InputDecoration(
              labelText: 'WiFi SSID',
              prefixIcon: Icon(Icons.wifi),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),
          
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'WiFi Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),

          const Spacer(),

          _buildConnectButton(),

          const SizedBox(height: 80),
        ]
      )
    );
  }

  Widget _buildTitle() {
    return Text(
      "Connect to network",
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildConnectButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onConnect,
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
          "Connect",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _onConnect() {
    // if (_ssidController.text.isEmpty) {
    //   setState(() {
    //     _isError = true;
    //     _errorMessage = 'Please enter a password';
    //   });
    //   return;
    // }

    setState(() => _isError = false);

    widget.onTryConnect.call(
      _ssidController.text,
      _passwordController.text
    );
  }
}
