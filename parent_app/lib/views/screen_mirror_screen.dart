import 'package:flutter/material.dart';
import '../core/theme.dart';

class ScreenMirrorView extends StatefulWidget {
  const ScreenMirrorView({super.key});

  @override
  State<ScreenMirrorView> createState() => _ScreenMirrorViewState();
}

class _ScreenMirrorViewState extends State<ScreenMirrorView> {
  bool isStreaming = true;
  String quality = 'HD (1080p)';

  @override
  Widget build(BuildContext context) {
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
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: AppTheme.glassmorphicCardDecoration,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Live Stream Mock Canvas
                        Container(
                          color: Colors.black,
                          child: Center(
                            child: isStreaming
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 240,
                                        height: 480,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1E1E1E),
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(color: AppTheme.accentBlue, width: 2),
                                        ),
                                        child: Stack(
                                          children: [
                                            // Mock Screen Content (e.g. YouTube player active on child phone)
                                            Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.play_circle_fill, color: Colors.red, size: 64),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Alex is watching YouTube',
                                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                                  ),
                                                  Text(
                                                    'Latency: 28ms • Encryption: AES-256',
                                                    style: TextStyle(color: Colors.grey, fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 12,
                                              right: 12,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                                                child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text('Stream Paused', style: TextStyle(color: Colors.white54)),
                          ),
                        ),

                        // Stream Controls Bar
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
                                  onPressed: () => setState(() => isStreaming = !isStreaming),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
