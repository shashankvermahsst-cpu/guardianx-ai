import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/app_providers.dart';

class ScreenMirrorView extends ConsumerStatefulWidget {
  const ScreenMirrorView({super.key});

  @override
  ConsumerState<ScreenMirrorView> createState() => _ScreenMirrorViewState();
}

class _ScreenMirrorViewState extends ConsumerState<ScreenMirrorView> {
  bool isStreaming = true;
  String quality = 'HD (1080p)';

  void _toggleMirrorStream() {
    final socket = ref.read(socketServiceProvider);
    setState(() => isStreaming = !isStreaming);
    socket.sendRemoteCommand('child-5501', isStreaming ? 'START_SCREEN_MIRROR' : 'STOP_SCREEN_MIRROR');
  }

  @override
  Widget build(BuildContext context) {
    final telemetryAsync = ref.watch(childTelemetryProvider);

    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('Live Screen Mirroring', style: TextStyle(fontWeight: FontWeight.bold)),
                actions: [
                  PopupMenuButton<String>(
                    initialValue: quality,
                    onSelected: (val) => setState(() => quality = val),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'HD (1080p)', child: Text('HD (1080p) - 60 FPS')),
                      const PopupMenuItem(value: 'SD (720p)', child: Text('SD (720p) - Low Data')),
                    ],
                    icon: const Icon(Icons.settings),
                  )
                ],
              ),
              Expanded(
                child: telemetryAsync.when(
                  data: (childData) {
                    if (childData == null) {
                      return const Center(
                        child: Text(
                          'No child device connected.\nPair child phone to view live screen.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.all(16),
                      decoration: AppTheme.glassmorphicCardDecoration,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Live Screen Display Canvas
                            Container(
                              color: Colors.black,
                              child: Center(
                                child: isStreaming
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 240,
                                            height: 460,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1E1E1E),
                                              borderRadius: BorderRadius.circular(24),
                                              border: Border.all(color: AppTheme.accentBlue, width: 2),
                                            ),
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Icon(Icons.phone_android, color: AppTheme.accentBlue, size: 64),
                                                      const SizedBox(height: 12),
                                                      Text(
                                                        'Active App: ${childData.currentApp}',
                                                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        '${childData.deviceName}\nBattery: ${childData.batteryLevel}% • ${childData.networkType}',
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 12,
                                                  right: 12,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                                                    child: const Text('LIVE STREAM', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Text('Screen Stream Paused', style: TextStyle(color: Colors.white54)),
                              ),
                            ),

                            // Controls Bar
                            Positioned(
                              bottom: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: AppTheme.primaryPurple),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(isStreaming ? Icons.pause_circle_filled : Icons.play_circle_filled, color: AppTheme.accentBlue, size: 36),
                                      onPressed: _toggleMirrorStream,
                                    ),
                                    const SizedBox(width: 15),
                                    Text(quality, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
