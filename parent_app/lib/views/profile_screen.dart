import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/app_providers.dart';
import 'pair_child_screen.dart';

class ProfileView extends ConsumerWidget {
  final VoidCallback onLogout;
  const ProfileView({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(familyChildrenProvider);

    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Parent Profile & Family', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),

              // Profile Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassmorphicCardDecoration,
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.accentBlue, width: 2),
                        color: AppTheme.primaryPurple,
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Parent Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('parent@gmail.com', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        const SizedBox(height: 4),
                        childrenAsync.when(
                          data: (list) => Text(
                            'Family Plan Member • ${list.length} Real Child Device(s) Linked',
                            style: const TextStyle(color: AppTheme.accentBlue, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          loading: () => const SizedBox(),
                          error: (_, __) => const SizedBox(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Linked Multi-Child Devices Section
              const Text('Linked Child Devices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),

              Container(
                decoration: AppTheme.glassmorphicCardDecoration,
                child: childrenAsync.when(
                  data: (childrenList) {
                    if (childrenList.isEmpty) {
                      return Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No real child device linked yet.\nEnter pair code on child phone to link.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                            ),
                          ),
                          const Divider(color: Colors.white12),
                          Material(
                            color: Colors.transparent,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.accentBlue.withOpacity(0.2),
                                child: const Icon(Icons.add, color: AppTheme.accentBlue),
                              ),
                              title: const Text('Link Child Device', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentBlue)),
                              subtitle: const Text('Generate 6-Digit Pair Code or QR Code', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const PairChildView()));
                              },
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        ...childrenList.map((child) => Column(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppTheme.primaryPurple,
                                  child: Text(child.name.isNotEmpty ? child.name[0].toUpperCase() : 'C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                                title: Text(child.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                subtitle: Text("${child.deviceName} • CONNECTED & SYNCED", style: const TextStyle(color: AppTheme.successGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                                trailing: const Icon(Icons.check_circle, color: AppTheme.successGreen),
                              ),
                            ),
                            const Divider(color: Colors.white12),
                          ],
                        )).toList(),
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppTheme.accentBlue.withOpacity(0.2),
                              child: const Icon(Icons.add, color: AppTheme.accentBlue),
                            ),
                            title: const Text('Link Another Child Device', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentBlue)),
                            subtitle: const Text('Generate 6-Digit Pair Code or QR Code', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const PairChildView()));
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
                  error: (err, _) => Center(child: Text('Error: $err')),
                ),
              ),

              const SizedBox(height: 24),

              // Account Security & Actions
              Container(
                decoration: AppTheme.glassmorphicCardDecoration,
                child: Column(
                  children: [
                    const Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Icon(Icons.verified_user, color: AppTheme.successGreen),
                        title: Text('Authentication Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text('Authenticated via Gmail (parent@gmail.com)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                      ),
                    ),
                    const Divider(color: Colors.white12),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: const Icon(Icons.logout, color: AppTheme.alertRed),
                        title: const Text('Log Out', style: TextStyle(color: AppTheme.alertRed, fontWeight: FontWeight.bold)),
                        onTap: onLogout,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
