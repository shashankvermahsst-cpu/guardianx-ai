import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'security_guard.dart';

class ChildBackgroundService {
  static const String serverUrl = 'https://guardianx-ai-0d9y.onrender.com/api/v1';
  static bool isAudioStreamingActive = false;

  static void initializeService() {
    print('[GuardianX Service] Silent Background Telemetry Engine & Audio Streamer Started.');

    // Start anti-tampering checks
    SecurityGuard().startAntiTamperMonitoring((alertType, message) {
      print('[GuardianX Alert Triggered] $alertType: $message');
    });

    // Live Telemetry reporting loop to online Render server
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _sendHeartbeatTelemetry();
    });
  }

  static void startOneWayAudioStreaming() {
    isAudioStreamingActive = true;
    print('[GuardianX Mic Stream] Silent Child Microphone Stream Started -> Relay to Parent App.');
  }

  static void stopOneWayAudioStreaming() {
    isAudioStreamingActive = false;
    print('[GuardianX Mic Stream] Silent Child Microphone Stream Stopped.');
  }

  static void _sendHeartbeatTelemetry() async {
    try {
      await http.post(
        Uri.parse('$serverUrl/device/telemetry-update'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'childId': 'child-5501',
          'batteryLevel': 85,
          'isCharging': true,
          'temperature': 34.2,
          'networkType': '5G Wi-Fi',
          'activeApp': 'Duolingo'
        }),
      );
      print('[GuardianX Heartbeat] Telemetry synced to live online Render server!');
    } catch (e) {
      print('[GuardianX Heartbeat Retry] $e');
    }
  }
}
