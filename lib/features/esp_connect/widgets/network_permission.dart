import 'package:flutter/material.dart';

class NetworkPermission extends StatelessWidget {
  final VoidCallback? onPressed;

  const NetworkPermission({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),

          _buildWifiIcon(),

          const SizedBox(height: 16),

          _buildPermissionText(),

          const SizedBox(height: 16),

          _buildPermissionContextText(),

          const Spacer(),

          _buildAllowButton(),

          const SizedBox(height: 80),
        ],
      )
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

  Widget _buildPermissionText() {
    return const Text(
      "Allow Network Access",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPermissionContextText() {
    return const Text(
      "To allow trains to be controlled, they must connect to the local network",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAllowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
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
          "Allow",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
