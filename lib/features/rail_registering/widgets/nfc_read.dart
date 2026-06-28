import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/nfc_data/rail.dart';
import 'package:train_dashboard_app/features/rail_registering/widgets/nfc_read_empty.dart';
import 'package:train_dashboard_app/features/rail_registering/widgets/nfc_read_view.dart';

class NfcRead extends StatelessWidget {
  final Rail? rail;

  const NfcRead({super.key, required this.rail});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: rail == null ? NfcReadEmpty() : NfcReadView(rail: rail!),
      );
  }
}