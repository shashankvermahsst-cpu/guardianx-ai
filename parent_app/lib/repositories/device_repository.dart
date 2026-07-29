import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class DeviceRepository {
  final String baseUrl;
  DeviceRepository({this.baseUrl = 'https://guardianx-ai-0d9y.onrender.com/api/v1'});

  Future<List<ChildDevice>> fetchFamilyChildren() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/family/children')).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body)['children'] as List;
        return list.map((data) => ChildDevice(
          childId: data['childId'] ?? 'child-real',
          name: data['name'] ?? "Child's Phone",
          deviceName: data['deviceName'] ?? "Android Phone",
          isOnline: data['isOnline'] ?? true,
          batteryLevel: data['batteryLevel'] ?? 85,
          isCharging: data['isCharging'] ?? true,
          temperature: (data['temperature'] as num?)?.toDouble() ?? 33.5,
          networkType: data['networkType'] ?? '5G Wi-Fi',
          screenTimeMinutesToday: data['screenTimeTodayMinutes'] ?? 0,
          currentApp: data['activeApp'] ?? 'Active Protection',
        )).toList();
      }
    } catch (e) {
      print('[DeviceRepository Error] $e');
    }
    return [];
  }

  Future<ChildDevice?> fetchTelemetry({String? childId}) async {
    try {
      final url = childId != null
          ? '$baseUrl/device/telemetry?childId=$childId'
          : '$baseUrl/device/telemetry';
      final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['telemetry'];
        if (data == null) return null;

        return ChildDevice(
          childId: data['childId'] ?? 'child-real',
          name: data['name'] ?? "Child's Phone",
          deviceName: data['deviceName'] ?? "Android Device",
          isOnline: data['isOnline'] ?? true,
          batteryLevel: data['batteryLevel'] ?? 85,
          isCharging: data['isCharging'] ?? true,
          temperature: (data['temperature'] as num?)?.toDouble() ?? 33.5,
          networkType: data['networkType'] ?? '5G Wi-Fi',
          screenTimeMinutesToday: data['screenTimeTodayMinutes'] ?? 0,
          currentApp: data['activeApp'] ?? 'Active Protection',
        );
      }
    } catch (e) {
      print('[DeviceRepository Error] $e');
    }
    return null;
  }

  Future<List<AppUsageItem>> fetchAppUsages() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/device/app-usage')).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body)['apps'] as List;
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
      print('[DeviceRepository Error] $e');
    }
    return [];
  }

  Future<bool> updateAppRule(String packageName, bool isBlocked) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/device/app-rules'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'packageName': packageName, 'isBlocked': isBlocked}),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
