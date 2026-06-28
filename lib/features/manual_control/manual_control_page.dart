import 'package:flutter/material.dart';
import 'package:train_dashboard_app/core/utils/train_motor_control.dart';

class ManualControlPage extends StatefulWidget {
  const ManualControlPage({super.key});

  @override
  State<ManualControlPage> createState() => _ManualControlPageState();
}

class _ManualControlPageState extends State<ManualControlPage> {
  bool engineOn = false;
  bool lightsOn = false;
  bool hornActive = false;

  int targetduty = 750;
  int startingDuty = 750;
  final int minMotorDuty = 750;
  final int maxMotorDuty = 1023;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manual Control"), centerTitle: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: isWide
                  ? Row(
                      children: [
                        Expanded(flex: 2, child: _buildSpeedCard()),
                        const SizedBox(width: 16),
                        Expanded(flex: 3, child: _buildControlsCard()),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(child: _buildSpeedCard()),
                        const SizedBox(height: 16),
                        Expanded(child: _buildControlsCard()),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpeedCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Speed",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: SizedBox(
                    height: 250,
                    child: Slider(
                      value: targetduty.toDouble(),
                      min: minMotorDuty.toDouble(),
                      max: maxMotorDuty.toDouble(),
                      activeColor: Colors.blue,
                      onChanged: (v) =>
                          setState(() => targetduty = v.toInt()),
                      onChangeStart: (v) {
                        startingDuty = v.toInt();
                      },
                      onChangeEnd: (v) async {
                        await TrainMotorControl.control(
                          0,
                          startingDuty,
                          targetduty,
                          engineOn,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "$targetduty",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text("Duty Cycle"),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Controls",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _toggle(
              title: "Engine",
              icon: Icons.power_settings_new,
              value: engineOn,
              activeColor: Colors.green,
              onChanged: (v) async {
                setState(() => engineOn = v);

                await TrainMotorControl.control(
                  0,
                  targetduty,
                  targetduty,
                  engineOn,
                );
              },
            ),

            const SizedBox(height: 12),

            _toggle(
              title: "Lights",
              icon: Icons.lightbulb_outline,
              value: lightsOn,
              activeColor: Colors.amber,
              onChanged: (v) => setState(() => lightsOn = v),
            ),

            const SizedBox(height: 12),

            _hornButton(),
          ],
        ),
      ),
    );
  }

  Widget _toggle({
    required String title,
    required IconData icon,
    required bool value,
    required Color activeColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: value ? activeColor : Colors.grey),
        title: Text(title),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: activeColor,
        ),
      ),
    );
  }

  Widget _hornButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.volume_up),
        label: const Text("Horn"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          setState(() => hornActive = true);

          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              setState(() => hornActive = false);
            }
          });
        },
      ),
    );
  }
}
