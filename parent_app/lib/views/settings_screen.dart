import 'package:flutter/material.dart';
import '../core/theme.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool antiTamper = true;
  bool rootAlert = true;
  bool vpnAlert = true;
  bool simAlert = true;
  bool biometricAuth = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Security & Anti-Tamper Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),

              Container(
                decoration: AppTheme.glassmorphicCardDecoration,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Anti-Uninstall Guard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Prevents child from uninstalling GuardianX without parent PIN', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      value: antiTamper,
                      activeColor: AppTheme.accentBlue,
                      onChanged: (val) => setState(() => antiTamper = val),
                    ),
                    const Divider(color: Colors.white12),
                    SwitchListTile(
                      title: const Text('Root / Jailbreak Detection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Instant alert if device modification attempt is detected', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      value: rootAlert,
                      activeColor: AppTheme.accentBlue,
                      onChanged: (val) => setState(() => rootAlert = val),
                    ),
                    const Divider(color: Colors.white12),
                    SwitchListTile(
                      title: const Text('VPN Bypass Guard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Alert & block VPN connections used to bypass web filter', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      value: vpnAlert,
                      activeColor: AppTheme.accentBlue,
                      onChanged: (val) => setState(() => vpnAlert = val),
                    ),
                    const Divider(color: Colors.white12),
                    SwitchListTile(
                      title: const Text('SIM Card Change Alert', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Triggers high severity alert if SIM card is swapped', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      value: simAlert,
                      activeColor: AppTheme.accentBlue,
                      onChanged: (val) => setState(() => simAlert = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text('Parent Security', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),

              Container(
                decoration: AppTheme.glassmorphicCardDecoration,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Biometric Fingerprint / FaceID', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Require fingerprint to open parent app', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      value: biometricAuth,
                      activeColor: AppTheme.primaryPurple,
                      onChanged: (val) => setState(() => biometricAuth = val),
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
