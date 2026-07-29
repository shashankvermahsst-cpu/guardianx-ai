import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/app_providers.dart';
import 'pair_child_screen.dart';

class HomeDashboardView extends ConsumerStatefulWidget {
  final Function(int tabIndex)? onNavigateTab;
  const HomeDashboardView({super.key, this.onNavigateTab});

  @override
  ConsumerState<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends ConsumerState<HomeDashboardView> {
  Timer? _liveSyncTimer;

  @override
  void initState() {
    super.initState();
    // Continuous 3-second live sync polling across different networks (4G/5G/Wi-Fi)
    _liveSyncTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        ref.refresh(familyChildrenProvider);
        ref.refresh(childTelemetryProvider);
      }
    });
  }

  @override
  void dispose() {
    _liveSyncTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final telemetryAsync = ref.watch(childTelemetryProvider);
    final childrenAsync = ref.watch(familyChildrenProvider);
    final alertsAsync = ref.watch(alertsProvider);
    final selectedChildId = ref.watch(selectedChildIdProvider);

    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: Column(
            children: [
              // Header Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    childrenAsync.when(
                      data: (childrenList) {
                        if (childrenList.isEmpty) {
                          return GestureDetector(
                            onTap: () => widget.onNavigateTab?.call(5),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.alertRed, width: 2),
                                    color: AppTheme.cardDarkBackground,
                                  ),
                                  child: const Icon(Icons.phonelink_off, color: AppTheme.alertRed, size: 20),
                                ),
                                const SizedBox(width: 10),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('GuardianX Parent', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                    Text('NOT CONNECTED • Waiting for Pair', style: TextStyle(fontSize: 11, color: AppTheme.alertRed, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }

                        final currentChild = childrenList.firstWhere(
                          (c) => c.childId == selectedChildId,
                          orElse: () => childrenList.first,
                        );

                        return PopupMenuButton<String>(
                          initialValue: currentChild.childId,
                          onSelected: (val) {
                            if (val == 'ADD_CHILD') {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const PairChildView()));
                            } else {
                              ref.read(selectedChildIdProvider.notifier).state = val;
                              ref.refresh(childTelemetryProvider);
                            }
                          },
                          itemBuilder: (context) => [
                            ...childrenList.map((c) => PopupMenuItem(
                              value: c.childId,
                              child: Row(
                                children: [
                                  const Icon(Icons.smartphone, color: AppTheme.accentBlue, size: 20),
                                  const SizedBox(width: 8),
                                  Text('${c.name} (${c.deviceName})'),
                                ],
                              ),
                            )),
                            const PopupMenuDivider(),
                            const PopupMenuItem(
                              value: 'ADD_CHILD',
                              child: Row(
                                children: [
                                  Icon(Icons.add_circle, color: AppTheme.successGreen, size: 20),
                                  SizedBox(width: 8),
                                  Text('+ Link Another Child Device', style: TextStyle(color: AppTheme.successGreen, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.cardDarkBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.accentBlue.withOpacity(0.5)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.successGreen, width: 2),
                                    color: AppTheme.primaryPurple,
                                  ),
                                  child: const Icon(Icons.person, color: Colors.white, size: 22),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          currentChild.name,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                                      ],
                                    ),
                                    Text(
                                      '${currentChild.deviceName} • LIVE SYNC (4G/5G)',
                                      style: const TextStyle(fontSize: 11, color: AppTheme.successGreen, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (err, _) => const SizedBox(),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.qr_code_2_rounded, color: AppTheme.accentBlue),
                          tooltip: 'Link Child Device',
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const PairChildView()));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.sync, color: AppTheme.successGreen),
                          tooltip: 'Live Refresh',
                          onPressed: () {
                            ref.refresh(familyChildrenProvider);
                            ref.refresh(childTelemetryProvider);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Body Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Render children connection check
                      childrenAsync.when(
                        data: (childrenList) {
                          if (childrenList.isEmpty) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppTheme.alertRed.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.alertRed, width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.portable_wifi_off_rounded, color: AppTheme.alertRed, size: 48),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'No Child Device Connected',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Open GuardianX Child App on your child\'s phone and enter the 6-Digit Pair Code (GX-9901) to sync live tracking across networks.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryPurple,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                      icon: const Icon(Icons.qr_code_2),
                                      label: const Text('Get 6-Digit Pair Code & QR Code', style: TextStyle(fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PairChildView()));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return telemetryAsync.when(
                            data: (data) {
                              if (data == null) return const SizedBox();
                              return GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                childAspectRatio: 1.6,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                children: [
                                  _buildMetricCard(
                                    icon: Icons.battery_charging_full,
                                    title: 'Battery Level',
                                    value: '${data.batteryLevel}%',
                                    subtitle: data.isCharging ? '⚡ Charging' : 'Discharging',
                                    color: AppTheme.successGreen,
                                    onTap: () => widget.onNavigateTab?.call(0),
                                  ),
                                  _buildMetricCard(
                                    icon: Icons.thermostat,
                                    title: 'Device Temp',
                                    value: '${data.temperature}°C',
                                    subtitle: 'Normal Range',
                                    color: AppTheme.accentBlue,
                                    onTap: () => widget.onNavigateTab?.call(0),
                                  ),
                                  _buildMetricCard(
                                    icon: Icons.wifi,
                                    title: 'Network Type',
                                    value: data.networkType,
                                    subtitle: 'Online Sync',
                                    color: AppTheme.primaryPurple,
                                    onTap: () => widget.onNavigateTab?.call(0),
                                  ),
                                  _buildMetricCard(
                                    icon: Icons.timer,
                                    title: 'Screen Time',
                                    value: '${data.screenTimeMinutesToday} min',
                                    subtitle: 'Goal: 180 min',
                                    color: Colors.amber,
                                    onTap: () => widget.onNavigateTab?.call(6),
                                  ),
                                ],
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (err, _) => Text('Error loading telemetry: $err'),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (err, _) => const SizedBox(),
                      ),

                      const SizedBox(height: 20),

                      // Quick Action Shortcuts Grid
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Remote Controls & Surveillance',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQuickAction(context, Icons.screen_share, 'Screen Mirror', AppTheme.primaryPurple, 2),
                          _buildQuickAction(context, Icons.camera_alt, 'Remote Camera', AppTheme.accentBlue, 3),
                          _buildQuickAction(context, Icons.graphic_eq, 'Listen Audio', Colors.pinkAccent, 4),
                          _buildQuickAction(context, Icons.map, 'Live GPS', AppTheme.successGreen, 1),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Security Alerts Section
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Recent Security Alerts',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      alertsAsync.when(
                        data: (alerts) => Column(
                          children: alerts.map((alert) => GestureDetector(
                            onTap: () => widget.onNavigateTab?.call(7),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: AppTheme.glassmorphicCardDecoration,
                              child: Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: alert.severity == 'high' ? AppTheme.alertRed.withOpacity(0.2) : AppTheme.accentBlue.withOpacity(0.2),
                                    child: Icon(
                                      alert.severity == 'high' ? Icons.warning_amber_rounded : Icons.shield_outlined,
                                      color: alert.severity == 'high' ? AppTheme.alertRed : AppTheme.accentBlue,
                                    ),
                                  ),
                                  title: Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                  subtitle: Text(alert.message, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (err, _) => const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({required IconData icon, required String title, required String value, required String subtitle, required Color color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: AppTheme.glassmorphicCardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(subtitle, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color, int targetTab) {
    return GestureDetector(
      onTap: () => widget.onNavigateTab?.call(targetTab),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color, width: 1.5),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }
}
