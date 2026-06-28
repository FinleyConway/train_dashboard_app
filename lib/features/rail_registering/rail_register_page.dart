import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/nfc_data/rail.dart';
import 'package:train_dashboard_app/features/rail_registering/controller/rail_nfc_scan.dart';

class RailRegisterPage extends StatefulWidget {
  const RailRegisterPage({super.key});

  @override
  State<RailRegisterPage> createState() => _RailRegisterPageState();
}

class _RailRegisterPageState extends State<RailRegisterPage>
    with SingleTickerProviderStateMixin {
  late RailNfcScan _controller;
  late TabController _tabController;

  Rail? railRead;
  RailType selected = RailType.vertical;

  @override
  void initState() {
    super.initState();

    _controller = RailNfcScan();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        onTabChanged(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();

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
      body: TabBarView(controller: _tabController, children: [write(), read()]),
    );
  }

  Widget write() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return SafeArea(
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rail Type",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 6),

                    _buildDropdownField(),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.nfc),
                        label: const Text("Write to NFC Tag"),
                        onPressed: onWrite,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget read() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: railRead == null ? _buildEmptyState() : _buildSimpleRailView(),
        );
      },
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownMenu<RailType>(
        initialSelection: selected,
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
        dropdownMenuEntries: RailType.values.map((type) {
          return DropdownMenuEntry(value: type, label: formatRailType(type));
        }).toList(),
        onSelected: (value) {
          setState(() {
            selected = value!;
          });
        },
      ),
    );
  }

  String formatRailType(RailType type) {
    return type.name[0].toUpperCase() + type.name.substring(1);
  }

  Future<void> onWrite() async {
    _showNfcWaitingDialog();

    final success = await _controller.registerRail(selected);

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
                    ? 'Rail registered successfully.'
                    : 'Failed to register rail.',
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

  Future<void> onTabChanged(int tabIndex) async {
    if (tabIndex == 0) {
      await _controller.stopReadScan();
    } else if (tabIndex == 1) {
      final result = await _controller.readRail();

      if (!mounted) return;

      setState(() {
        railRead = result;
      });
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

  Widget _buildEmptyState() {
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

  Widget _buildSimpleRailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Rail ID", style: TextStyle(color: Colors.grey)),

        const SizedBox(height: 6),

        SelectableText(
          railRead!.railId.toString(),
          style: const TextStyle(fontSize: 18),
        ),

        const SizedBox(height: 24),

        const Text("Rail Type", style: TextStyle(color: Colors.grey)),

        const SizedBox(height: 6),

        Text(
          formatRailType(railRead!.railType),
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
