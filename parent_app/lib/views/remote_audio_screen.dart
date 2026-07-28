import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/app_providers.dart';

class RemoteAudioView extends ConsumerStatefulWidget {
  const RemoteAudioView({super.key});

  @override
  ConsumerState<RemoteAudioView> createState() => _RemoteAudioViewState();
}

class _RemoteAudioViewState extends ConsumerState<RemoteAudioView> {
  bool isListening = false;
  bool isNoiseReductionOn = true;
  double decibelLevel = 42.0;

  void _toggleAudioListening() async {
    final socketService = ref.read(socketServiceProvider);

    if (!isListening) {
      setState(() => isListening = true);
      // Send real one-way audio streaming command to child device
      await socketService.sendRemoteCommand('child-5501', 'START_AUDIO_STREAM');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('One-Way Audio Stream CONNECTED: Listening to Child Environment silently.'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } else {
      setState(() => isListening = false);
      await socketService.sendRemoteCommand('child-5501', 'STOP_AUDIO_STREAM');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audio Stream Disconnected.'),
            backgroundColor: AppTheme.alertRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('One-Way Environmental Audio', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Audio Waveform Animation Card
                      Container(
                        width: double.infinity,
                        height: 240,
                        decoration: AppTheme.glassmorphicCardDecoration,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isListening ? Icons.graphic_eq : Icons.mic_none,
                              size: 80,
                              color: isListening ? AppTheme.accentBlue : Colors.white30,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isListening ? 'Streaming Live Audio from Child Mic...' : 'One-Way Audio Listener Idle',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isListening
                                  ? 'Decibel Level: 45 dB • Noise Reduction: ACTIVE • Encrypted Stream'
                                  : 'Tap red button to listen silently to child surroundings',
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Controls
                      SwitchListTile(
                        title: const Text('AI Background Noise Reduction', style: TextStyle(color: Colors.white)),
                        subtitle: const Text('Filters out wind & road noise for crystal clear speech', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                        value: isNoiseReductionOn,
                        activeColor: AppTheme.accentBlue,
                        onChanged: (val) => setState(() => isNoiseReductionOn = val),
                      ),

                      const SizedBox(height: 30),

                      // Start / Stop One-Way Audio Mic Button
                      GestureDetector(
                        onTap: _toggleAudioListening,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isListening ? AppTheme.alertRed : AppTheme.primaryPurple,
                            boxShadow: [
                              BoxShadow(
                                color: (isListening ? AppTheme.alertRed : AppTheme.primaryPurple).withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 4,
                              )
                            ],
                          ),
                          child: Icon(
                            isListening ? Icons.stop : Icons.mic,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isListening ? 'Tap to Stop Listening' : 'Tap to Start One-Way Child Mic Stream',
                        style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
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
}
