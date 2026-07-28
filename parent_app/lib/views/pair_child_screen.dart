import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/app_providers.dart';

class PairChildView extends ConsumerStatefulWidget {
  const PairChildView({super.key});

  @override
  ConsumerState<PairChildView> createState() => _PairChildViewState();
}

class _PairChildViewState extends ConsumerState<PairChildView> {
  String pairCode = 'GX-9901';
  bool isLoading = false;

  void _generateNewCode() async {
    setState(() => isLoading = true);
    final repo = ref.read(authRepositoryProvider);
    final res = await repo.generatePairingCode('token');
    setState(() {
      isLoading = false;
      pairCode = res['pairCode'] ?? 'GX-9901';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AppBar(
                  title: const Text('Link & Pair Child Device', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),

                // Instruction Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.glassmorphicCardDecoration,
                  child: Column(
                    children: [
                      const Icon(Icons.qr_code_scanner, size: 60, color: AppTheme.accentBlue),
                      const SizedBox(height: 12),
                      const Text(
                        'Step-by-Step Pairing',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '1. Open GuardianX Child App on your child\'s phone.\n2. Enter this 6-digit code or scan the QR Code below.\n3. Grant required background & location permissions.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 24),

                      // 6-Digit Pair Code Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.accentBlue, width: 2),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                pairCode,
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 4, color: Colors.white),
                              ),
                      ),

                      const SizedBox(height: 16),
                      TextButton.icon(
                        icon: const Icon(Icons.refresh, color: AppTheme.accentBlue),
                        label: const Text('Generate New Pair Code', style: TextStyle(color: AppTheme.accentBlue)),
                        onPressed: _generateNewCode,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // QR Code Simulation Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.glassmorphicCardDecoration,
                  child: Column(
                    children: [
                      const Text('Scan QR Code with Child Device', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 16),
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(Icons.qr_code_2_rounded, size: 160, color: Colors.black),
                        ),
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
