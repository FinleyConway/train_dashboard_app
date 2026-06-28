import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/nfc_data/rail.dart';
import 'package:train_dashboard_app/features/rail_registering/controller/rail_nfc_scan.dart';
import 'package:train_dashboard_app/features/rail_registering/widgets/nfc_read.dart';
import 'package:train_dashboard_app/features/rail_registering/widgets/nfc_write.dart';

class RailRegisterPage extends StatefulWidget {
  const RailRegisterPage({super.key});

  @override
  State<RailRegisterPage> createState() => _RailRegisterPageState();
}

class _RailRegisterPageState extends State<RailRegisterPage>
    with SingleTickerProviderStateMixin {
  late RailNfcScan _controller;
  late TabController _tabController;

  Rail? _rail;
  RailType _selected = RailType.vertical;
  bool _isReading = false;

  @override
  void initState() {
    super.initState();

    _controller = RailNfcScan();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        _onTabChanged(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Rail"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.nfc, color: Colors.blue),
              text: "Write",
            ),
            Tab(
              icon: Icon(Icons.radar, color: Colors.green),
              text: "Read",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NfcWrite(
            selected: _selected,
            onRailTypeChanged: (value) => setState(() {
              _selected = value;
            }),
            onWrite: _onWrite,
          ),
          NfcRead(rail: _rail),
        ],
      ),
    );
  }

  Future<void> _onWrite() async {
    _showNfcWaitingDialog();

    final success = await _controller.registerRail(_selected);

    if (!mounted) return;

    Navigator.of(context).pop(); // close dialog

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                success
                    ? "Rail registered successfully."
                    : "Failed to register rail.",
              ),
            ),
          ],
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _onTabChanged(int tabIndex) async {
    if (tabIndex == 0) {
      _stopReadLoop();
    } else if (tabIndex == 1) {
      _startReadLoop();
    }
  }

  void _showNfcWaitingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.nfc, size: 48),

              SizedBox(height: 16),

              Text(
                "Hold device near NFC tag",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              Text("Waiting for scan...", textAlign: TextAlign.center),

              SizedBox(height: 16),

              LinearProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startReadLoop() async {
    if (_isReading) return;

    _isReading = true;

    while (_isReading && mounted) {
      final result = await _controller.readRail();

      if (!mounted || !_isReading) break;

      if (result != null) {
        setState(() {
          _rail = result;
        });

        await Future.delayed(const Duration(seconds: 3));
      }
    }

  }

  void _stopReadLoop() {
    _isReading = false;
    _controller.stopReadScan();
  }
}
