import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/nfc_data/rail.dart';

class RailRegisterPage extends StatefulWidget {
  const RailRegisterPage({super.key});

  @override
  State<RailRegisterPage> createState() => _RailRegisterPageState();
}

class _RailRegisterPageState extends State<RailRegisterPage> {
  RailType selected = RailType.vertical;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Widget createDropDown() {
    return DropdownMenu<RailType>(
      initialSelection: selected,
      dropdownMenuEntries: RailType.values.map((type) {
        return DropdownMenuEntry(
          value: type,
          label: formatRailType(type),
        );
      }).toList(),
      onSelected: (value) {
        setState(() {
          selected = value!;
        });
      },
    );
  }

  String formatRailType(RailType type) {
    return type.name[0].toUpperCase() + type.name.substring(1); 
  }
}