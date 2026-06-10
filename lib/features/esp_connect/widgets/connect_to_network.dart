import 'package:flutter/material.dart';

class ConnectToNetwork extends StatefulWidget {
  final String? ssid;
  final String? errorMessage;
  final Function(String, String) onTryConnect;

  const ConnectToNetwork({super.key, required this.onTryConnect, this.ssid, this.errorMessage});

  @override
  State<ConnectToNetwork> createState() => _ConnectToNetworkState();
}

class _ConnectToNetworkState extends State<ConnectToNetwork> {
  late final TextEditingController _ssidController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    _ssidController = TextEditingController(text: widget.ssid ?? "");
    _passwordController = TextEditingController();
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
            controller: _ssidController,
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
          
          if (widget.errorMessage != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.error_outline, size: 16, color: Colors.red),
                const SizedBox(width: 6),
                Text(
                  widget.errorMessage!,
                  style: const TextStyle(fontSize: 13, color: Colors.red),
                ),
              ],
            ),
          ],

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
    widget.onTryConnect.call(
      _ssidController.text,
      _passwordController.text
    );
  }
}
