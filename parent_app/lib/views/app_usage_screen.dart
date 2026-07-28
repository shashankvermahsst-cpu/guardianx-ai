import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/app_providers.dart';

class AppUsageView extends ConsumerWidget {
  const AppUsageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUsageAsync = ref.watch(appUsagesProvider);

    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('App Management & Blocker', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: appUsageAsync.when(
                  data: (apps) => ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      final app = apps[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: AppTheme.glassmorphicCardDecoration,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryPurple.withOpacity(0.3),
                            child: Icon(
                              _getAppIcon(app.appName),
                              color: AppTheme.accentBlue,
                            ),
                          ),
                          title: Text(app.appName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          subtitle: Text(
                            'Time Used Today: ${app.minutesUsed} mins • Category: ${app.category}',
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                          trailing: Switch(
                            value: !app.isBlocked,
                            activeColor: AppTheme.successGreen,
                            inactiveThumbColor: AppTheme.alertRed,
                            onChanged: (allowed) async {
                              final newBlockedState = !allowed;
                              app.isBlocked = newBlockedState;
                              
                              // Send real backend rule update
                              final repo = ref.read(deviceRepositoryProvider);
                              await repo.updateAppRule(app.packageName, newBlockedState);
                              
                              ref.refresh(appUsagesProvider);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${app.appName} ${newBlockedState ? 'BLOCKED' : 'UNLOCKED'} on child device!'),
                                  backgroundColor: newBlockedState ? AppTheme.alertRed : AppTheme.successGreen,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Error loading app usages: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getAppIcon(String appName) {
    final name = appName.toLowerCase();
    if (name.contains('youtube')) return Icons.play_arrow_rounded;
    if (name.contains('tiktok')) return Icons.music_note_rounded;
    if (name.contains('roblox')) return Icons.sports_esports_rounded;
    if (name.contains('instagram')) return Icons.camera_alt_rounded;
    return Icons.apps_rounded;
  }
}
