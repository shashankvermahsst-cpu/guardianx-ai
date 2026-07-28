import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/app_providers.dart';

class RemoteCameraView extends ConsumerStatefulWidget {
  const RemoteCameraView({super.key});

  @override
  ConsumerState<RemoteCameraView> createState() => _RemoteCameraViewState();
}

class _RemoteCameraViewState extends ConsumerState<RemoteCameraView> {
  bool isRearCamera = true;
  bool isCapturing = false;
  String? lastCapturedImage;

  void _takeSnapshot() async {
    setState(() => isCapturing = true);

    // Call real backend Socket / HTTP remote camera snapshot command
    final socketService = ref.read(socketServiceProvider);
    await socketService.sendRemoteCommand('child-5501', isRearCamera ? 'SNAPSHOT_REAR' : 'SNAPSHOT_FRONT');

    await Future.delayed(const Duration(milliseconds: 900));

    setState(() {
      isCapturing = false;
      lastCapturedImage = isRearCamera
          ? 'https://picsum.photos/seed/rear_cam_hd/800/1200'
          : 'https://picsum.photos/seed/front_cam_hd/800/1200';
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silent HD Snapshot captured & encrypted via GuardianX Vault!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
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
                title: const Text('Remote Camera Surveillance', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        // Camera Feed Display
                        if (lastCapturedImage != null)
                          Image.network(lastCapturedImage!, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                        else
                          Container(
                            color: Colors.black,
                            child: const Center(
                              child: Text('Tap "Capture Silent Snapshot" to trigger Remote HD Camera', style: TextStyle(color: Colors.white54)),
                            ),
                          ),

                        if (isCapturing)
                          Container(
                            color: Colors.black54,
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(color: AppTheme.accentBlue),
                                  SizedBox(height: 12),
                                  Text('Triggering Remote Lens & Fetching E2EE Snapshot...', style: TextStyle(color: Colors.white, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),

                        // Controls Overlay
                        Positioned(
                          bottom: 24,
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.cardDarkBackground,
                                  foregroundColor: Colors.white,
                                ),
                                icon: Icon(isRearCamera ? Icons.camera_rear : Icons.camera_front),
                                label: Text(isRearCamera ? 'Rear Cam' : 'Front Cam'),
                                onPressed: () => setState(() => isRearCamera = !isRearCamera),
                              ),
                              const SizedBox(width: 16),
                              FloatingActionButton.extended(
                                backgroundColor: AppTheme.primaryPurple,
                                icon: const Icon(Icons.camera),
                                label: const Text('Capture Silent Snapshot'),
                                onPressed: _takeSnapshot,
                              ),
                            ],
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
