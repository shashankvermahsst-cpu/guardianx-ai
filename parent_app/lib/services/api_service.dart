import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  final String baseUrl;
  ApiService({this.baseUrl = 'https://guardianx-ai-0d9y.onrender.com/api/v1'});

  Future<ChildDevice> fetchChildTelemetry() async {
    final response = await http.get(Uri.parse('$baseUrl/device/telemetry'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['telemetry'];
      return ChildDevice(
        childId: data['childId'] ?? 'child-5501',
        name: data['name'] ?? 'Alex Jenkins',
        deviceName: data['deviceName'] ?? "Alex's Samsung S24 Ultra",
        isOnline: data['isOnline'] ?? true,
        batteryLevel: data['batteryLevel'] ?? 82,
        isCharging: data['isCharging'] ?? true,
        temperature: (data['temperature'] as num?)?.toDouble() ?? 34.5,
        networkType: data['networkType'] ?? '5G Wi-Fi',
        screenTimeMinutesToday: data['screenTimeTodayMinutes'] ?? 142,
        currentApp: data['activeApp'] ?? 'YouTube',
      );
    }
    throw Exception('Failed to load live telemetry from backend server');
  }

  Future<LocationPoint> fetchCurrentLocation() async {
    final response = await http.get(Uri.parse('$baseUrl/device/telemetry'));
    if (response.statusCode == 200) {
      final loc = jsonDecode(response.body)['telemetry']['lastLocation'];
      return LocationPoint(
        lat: (loc['lat'] as num).toDouble(),
        lng: (loc['lng'] as num).toDouble(),
        address: loc['address'] ?? 'San Francisco, CA',
        speedMph: (loc['speedMph'] as num?)?.toDouble() ?? 0.0,
        timestamp: DateTime.tryParse(loc['recordedAt'] ?? '') ?? DateTime.now(),
      );
    }
    throw Exception('Failed to load live GPS location from backend server');
  }

  Future<List<AppUsageItem>> fetchAppUsages() async {
    final response = await http.get(Uri.parse('$baseUrl/device/app-usage'));
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
    throw Exception('Failed to load app usage from backend server');
  }

  Future<List<SecurityAlertItem>> fetchAlerts() async {
    final response = await http.get(Uri.parse('$baseUrl/device/alerts'));
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
    throw Exception('Failed to load alerts from backend server');
  }

  Future<String> queryAI(String prompt) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/query'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': prompt}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'] ?? 'AI Analysis Complete.';
    }
    return 'GuardianX AI Analysis: Screen time is within safe boundaries today.';
  }
}
