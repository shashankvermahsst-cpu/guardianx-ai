import 'package:flutter/material.dart';
import '../core/theme.dart';

class ScreenTimeView extends StatefulWidget {
  const ScreenTimeView({super.key});

  @override
  State<ScreenTimeView> createState() => _ScreenTimeViewState();
}

class _ScreenTimeViewState extends State<ScreenTimeView> {
  double dailyLimitHours = 3.0;
  bool isBedtimeEnabled = true;
  bool isSchoolModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Screen Time Controls', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),

                // Daily Limit Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.glassmorphicCardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Daily Limit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('${dailyLimitHours.toStringAsFixed(1)} Hours', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentBlue)),
                        ],
                      ),
                      Slider(
                        value: dailyLimitHours,
                        min: 0.5,
                        max: 8.0,
                        divisions: 15,
                        activeColor: AppTheme.primaryPurple,
                        onChanged: (val) => setState(() => dailyLimitHours = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Bed Time Schedule Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.glassmorphicCardDecoration,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Bedtime Lock Mode', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        subtitle: const Text('Locks all apps automatically between 09:30 PM - 06:30 AM', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        value: isBedtimeEnabled,
                        activeColor: AppTheme.accentBlue,
                        onChanged: (val) => setState(() => isBedtimeEnabled = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // School Mode Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.glassmorphicCardDecoration,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('School Focus Mode', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        subtitle: const Text('Only educational apps allowed during school hours (08:00 AM - 03:00 PM)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        value: isSchoolModeEnabled,
                        activeColor: AppTheme.accentBlue,
                        onChanged: (val) => setState(() => isSchoolModeEnabled = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
