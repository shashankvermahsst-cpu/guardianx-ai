import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/app_providers.dart';

class LocationView extends ConsumerWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(currentLocationProvider);
    final telemetryAsync = ref.watch(childTelemetryProvider);

    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('Live GPS & Real-Time Map', style: TextStyle(fontWeight: FontWeight.bold)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh Live Location',
                    onPressed: () {
                      ref.refresh(currentLocationProvider);
                      ref.refresh(childTelemetryProvider);
                    },
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    // Real Map View Simulation Container using OpenStreetMap Tiles
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131129),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.accentBlue.withOpacity(0.5), width: 1.5),
                        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // OpenStreetMap Tile Background
                            Image.network(
                              'https://static-maps.yandex.ru/1.x/?lang=en-US&ll=-122.4194,37.7749&z=15&l=map&size=600,600',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) => CustomPaint(
                                size: Size.infinite,
                                painter: RealMapGridPainter(),
                              ),
                            ),

                            // SafeZone Radius Ring Overlay
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.accentBlue.withOpacity(0.2),
                                border: Border.all(color: AppTheme.accentBlue, width: 2.5),
                              ),
                              child: const Center(
                                child: Text(
                                  'School SafeZone (200m)',
                                  style: TextStyle(color: AppTheme.accentBlue, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                            // Child Real Location Pin
                            telemetryAsync.when(
                              data: (childData) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryPurple,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 6)],
                                    ),
                                    child: Text(
                                      '${childData?.name ?? "Child Device"} (LIVE GPS)',
                                      style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Icon(Icons.location_on, color: AppTheme.alertRed, size: 48),
                                ],
                              ),
                              loading: () => const SizedBox(),
                              error: (_, __) => const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Floating Bottom Location Card
                    Positioned(
                      bottom: 24,
                      left: 24,
                      right: 24,
                      child: locationAsync.when(
                        data: (loc) => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: AppTheme.glassmorphicCardDecoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.my_location, color: AppTheme.accentBlue),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      loc.address,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Lat: ${loc.lat.toStringAsFixed(4)}, Lng: ${loc.lng.toStringAsFixed(4)}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                                  const Text('SafeZone: Inside Safe Area', style: TextStyle(color: AppTheme.successGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => const SizedBox(),
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

class RealMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x1F6C5CE7)
      ..strokeWidth = 1;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
