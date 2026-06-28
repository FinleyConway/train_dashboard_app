import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/nfc_data/rail.dart';

class NfcReadView extends StatelessWidget {
  final Rail rail;

  const NfcReadView({super.key, required this.rail});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Rail ID", style: TextStyle(color: Colors.grey)),

        const SizedBox(height: 6),

        SelectableText(
          rail.railId.toString(),
          style: const TextStyle(fontSize: 18),
        ),

        const SizedBox(height: 24),

        const Text("Rail Type", style: TextStyle(color: Colors.grey)),

        const SizedBox(height: 6),

        Text(
          rail.railType.name,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}