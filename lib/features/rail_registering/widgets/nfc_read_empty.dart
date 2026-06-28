import 'package:flutter/material.dart';

class NfcReadEmpty extends StatelessWidget {
  const NfcReadEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.radar, size: 64, color: Colors.grey),
          
          SizedBox(height: 16),

          Text("Waiting for NFC tag", style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),

          Text(
            "Hold your device near a rail tag",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
