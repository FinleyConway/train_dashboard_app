import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/nfc_data/rail.dart';

class RailTypeDropdown extends StatelessWidget {
  final RailType value;
  final ValueChanged<RailType> onSelected;

  const RailTypeDropdown({
    super.key,
    required this.value,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<RailType>(
      width: double.infinity,
      initialSelection: value,
      dropdownMenuEntries: RailType.values.map((type) {
        return DropdownMenuEntry(
          value: type,
          label: type.name,
        );
      }).toList(),
      onSelected: (value) {
        if (value != null) {
          onSelected(value);
        }
      },
    );
  }
}