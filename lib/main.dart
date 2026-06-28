import 'package:flutter/material.dart';
import 'package:train_dashboard_app/features/esp_connect/esp_connect_page.dart';
import 'package:train_dashboard_app/features/manual_control/manual_control_page.dart';
import 'package:train_dashboard_app/features/rail_registering/rail_register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ManualControlPage(),
    );
  }
}
