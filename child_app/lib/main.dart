import 'package:flutter/material.dart';
import 'services/background_service.dart';
import 'views/permission_manager_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ChildBackgroundService.initializeService();
  runApp(const GuardianXChildApp());
}

class GuardianXChildApp extends StatefulWidget {
  const GuardianXChildApp({super.key});

  @override
  State<GuardianXChildApp> createState() => _GuardianXChildAppState();
}

class _GuardianXChildAppState extends State<GuardianXChildApp> {
  bool _isPaired = false;
  String _parentEmail = 'parent@gmail.com';
  String _pairCode = 'GX-9901';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GuardianX Child Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: _isPaired
          ? ChildActiveProtectionView(
              parentEmail: _parentEmail,
              pairCode: _pairCode,
              onDisconnect: () => setState(() => _isPaired = false),
            )
          : ChildPermissionManagerView(
              onPairingComplete: (email, code) {
                setState(() {
                  _parentEmail = email;
                  _pairCode = code;
                  _isPaired = true;
                });
              },
            ),
    );
  }
}

class ChildActiveProtectionView extends StatelessWidget {
  final String parentEmail;
  final String pairCode;
  final VoidCallback onDisconnect;

  const ChildActiveProtectionView({
    super.key,
    required this.parentEmail,
    required this.pairCode,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shield, size: 90, color: Color(0xFF2ED573)),
                const SizedBox(height: 20),
                const Text(
                  'CONNECTED & PROTECTED',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2ED573), letterSpacing: 1),
                ),
                const SizedBox(height: 10),
                Text(
                  'Synced with Parent Gmail: $parentEmail\nPairing Code: $pairCode',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1736),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2ED573)),
                  ),
                  child: Column(
                    children: const [
                      Text('● Background Telemetry: LIVE', style: TextStyle(color: Color(0xFF2ED573), fontSize: 12, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('● GPS Tracking & App Blocker: ACTIVE', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF4757),
                    side: const BorderSide(color: Color(0xFFFF4757)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.link_off),
                  label: const Text('Disconnect & Re-Pair Device'),
                  onPressed: onDisconnect,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
