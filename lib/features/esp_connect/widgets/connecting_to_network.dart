import 'package:flutter/material.dart';

class ConnectingToNetwork extends StatelessWidget {
  
  const ConnectingToNetwork({super.key});

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),

          const Icon(Icons.wifi, size: 64),

          const SizedBox(height: 24),

          const Text(
            'Connecting',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 32),

          const CircularProgressIndicator(),

          const Spacer(),
        ],
      ),
    );
  }
}