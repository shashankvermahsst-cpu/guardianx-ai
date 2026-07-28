import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'pair_child_screen.dart';

class ProfileView extends StatelessWidget {
  final VoidCallback onLogout;
  const ProfileView({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
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
                        image: const DecorationImage(
                          image: NetworkImage('https://i.pravatar.cc/150?img=32'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Sarah Jenkins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('parent@gmail.com', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        SizedBox(height: 4),
                        Text('Family Plan Member • 2 Child Devices Linked', style: TextStyle(color: AppTheme.accentBlue, fontSize: 11, fontWeight: FontWeight.bold)),
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
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppTheme.primaryPurple,
                        child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      title: const Text('Alex Jenkins', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: const Text("Samsung S24 Ultra • CONNECTED & SYNCED", style: TextStyle(color: AppTheme.successGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.check_circle, color: AppTheme.successGreen),
                    ),
                    const Divider(color: Colors.white12),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppTheme.accentBlue,
                        child: Text('M', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                      title: const Text('Maya Jenkins (2nd Child)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: const Text("Google Pixel 8 • CONNECTED & SYNCED", style: TextStyle(color: AppTheme.successGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.check_circle, color: AppTheme.successGreen),
                    ),
                    const Divider(color: Colors.white12),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.accentBlue.withOpacity(0.2),
                        child: const Icon(Icons.add, color: AppTheme.accentBlue),
                      ),
                      title: const Text('Link Another Child Device', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentBlue)),
                      subtitle: const Text('Generate pair code or scan QR code', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PairChildView()));
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Account Security & Actions
              Container(
                decoration: AppTheme.glassmorphicCardDecoration,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.verified_user, color: AppTheme.successGreen),
                      title: const Text('Authentication Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Authenticated via Gmail (parent@gmail.com)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    ),
                    const Divider(color: Colors.white12),
                    ListTile(
                      leading: const Icon(Icons.logout, color: AppTheme.alertRed),
                      title: const Text('Log Out', style: TextStyle(color: AppTheme.alertRed, fontWeight: FontWeight.bold)),
                      onTap: onLogout,
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
