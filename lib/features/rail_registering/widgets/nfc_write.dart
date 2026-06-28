import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/nfc_data/rail.dart';
import 'package:train_dashboard_app/features/rail_registering/widgets/rail_type_dropdown.dart';

class NfcWrite extends StatelessWidget {
  final RailType selected;
  final ValueChanged<RailType> onRailTypeChanged;
  final VoidCallback onWrite;

  const NfcWrite({
    super.key,
    required this.selected,
    required this.onRailTypeChanged,
    required this.onWrite,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rail Type",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 6),

            RailTypeDropdown(
              value: selected,
              onSelected: onRailTypeChanged,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onWrite,
                icon: const Icon(Icons.nfc),
                label: const Text("Write to NFC Tag"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}