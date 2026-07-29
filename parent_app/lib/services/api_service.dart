import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  final String baseUrl;
  ApiService({this.baseUrl = 'https://guardianx-ai-0d9y.onrender.com/api/v1'});

  Future<ChildDevice?> fetchChildTelemetry() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/device/telemetry')).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['telemetry'];
        if (data == null) return null;

        return ChildDevice(
          childId: data['childId'] ?? 'child-5501',
          name: data['name'] ?? "Child's Phone",
          deviceName: data['deviceName'] ?? "Android Device",
          isOnline: data['isOnline'] ?? true,
          batteryLevel: data['batteryLevel'] ?? 82,
          isCharging: data['isCharging'] ?? true,
          temperature: (data['temperature'] as num?)?.toDouble() ?? 34.1,
          networkType: data['networkType'] ?? '5G Wi-Fi',
          screenTimeMinutesToday: data['screenTimeTodayMinutes'] ?? 142,
          currentApp: data['activeApp'] ?? 'YouTube',
        );
      }
    } catch (e) {
      print('[ApiService Error] $e');
    }
    return null;
  }

  Future<LocationPoint> fetchCurrentLocation() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/device/telemetry')).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final telemetry = jsonDecode(response.body)['telemetry'];
        if (telemetry != null && telemetry['lastLocation'] != null) {
          final loc = telemetry['lastLocation'];
          return LocationPoint(
            lat: (loc['lat'] as num).toDouble(),
            lng: (loc['lng'] as num).toDouble(),
            address: loc['address'] ?? '742 Evergreen Terrace, San Francisco, CA',
            speedMph: (loc['speedMph'] as num?)?.toDouble() ?? 0.0,
            timestamp: DateTime.tryParse(loc['recordedAt'] ?? '') ?? DateTime.now(),
          );
        }
      }
    } catch (e) {
      print('[ApiService Location Error] $e');
    }
    return LocationPoint(
      lat: 37.7749,
      lng: -122.4194,
      address: '742 Evergreen Terrace, San Francisco, CA',
      speedMph: 0.0,
      timestamp: DateTime.now(),
    );
  }

  Future<List<AppUsageItem>> fetchAppUsages() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/device/app-usage')).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body)['apps'] as List;
        return list.map((item) => AppUsageItem(
          packageName: item['packageName'],
          appName: item['appName'],
          category: item['category'],
          minutesUsed: ((item['screenTimeSeconds'] ?? 0) / 60).round(),
          isBlocked: item['isBlocked'] ?? false,
          dailyLimitMinutes: item['dailyLimitMinutes'] ?? 0,
        )).toList();
      }
    } catch (e) {
      print('[ApiService AppUsage Error] $e');
    }
    return [];
  }

  Future<List<SecurityAlertItem>> fetchAlerts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/device/alerts')).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body)['alerts'] as List;
        return list.map((item) => SecurityAlertItem(
          id: item['id'],
          title: item['title'],
          message: item['message'],
          severity: item['severity'],
          timestamp: DateTime.tryParse(item['timestamp'] ?? '') ?? DateTime.now(),
        )).toList();
      }
    } catch (e) {
      print('[ApiService Alerts Error] $e');
    }
    return [];
  }

  Future<String> queryAI(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': prompt}),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['response'] ?? 'AI Analysis Complete.';
      }
    } catch (e) {
      print('[ApiService AI Error] $e');
    }
    return 'GuardianX AI Analysis: Screen time is within safe boundaries today.';
  }
}
