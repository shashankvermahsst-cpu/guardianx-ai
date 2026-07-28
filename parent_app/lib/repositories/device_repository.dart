import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class DeviceRepository {
  final String baseUrl;
  DeviceRepository({this.baseUrl = 'http://localhost:4000/api/v1'});

  Future<List<ChildDevice>> fetchFamilyChildren() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/family/children'));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body)['children'] as List;
        return list.map((data) => ChildDevice(
          childId: data['childId'] ?? 'child-5501',
          name: data['name'] ?? 'Alex Jenkins',
          deviceName: data['deviceName'] ?? "Samsung S24 Ultra",
          isOnline: data['isOnline'] ?? true,
          batteryLevel: data['batteryLevel'] ?? 82,
          isCharging: data['isCharging'] ?? true,
          temperature: (data['temperature'] as num?)?.toDouble() ?? 34.5,
          networkType: data['networkType'] ?? '5G Wi-Fi',
          screenTimeMinutesToday: data['screenTimeTodayMinutes'] ?? 142,
          currentApp: data['activeApp'] ?? 'YouTube',
        )).toList();
      }
    } catch (e) {
      print('[DeviceRepository Error] $e');
    }
    return [
      ChildDevice(childId: 'child-5501', name: 'Alex Jenkins', deviceName: "Alex's Samsung S24 Ultra", isOnline: true, batteryLevel: 82, isCharging: true, temperature: 34.5, networkType: '5G Wi-Fi', screenTimeMinutesToday: 142, currentApp: 'YouTube'),
      ChildDevice(childId: 'child-5502', name: 'Maya Jenkins (2nd Child)', deviceName: "Maya's Google Pixel 8", isOnline: true, batteryLevel: 94, isCharging: false, temperature: 32.1, networkType: '4G Cellular', screenTimeMinutesToday: 48, currentApp: 'Duolingo'),
    ];
  }

  Future<ChildDevice> fetchTelemetry({String childId = 'child-5501'}) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/device/telemetry?childId=$childId'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['telemetry'];
        return ChildDevice(
          childId: data['childId'] ?? childId,
          name: data['name'] ?? 'Alex Jenkins',
          deviceName: data['deviceName'] ?? "Samsung S24 Ultra",
          isOnline: data['isOnline'] ?? true,
          batteryLevel: data['batteryLevel'] ?? 82,
          isCharging: data['isCharging'] ?? true,
          temperature: (data['temperature'] as num?)?.toDouble() ?? 34.5,
          networkType: data['networkType'] ?? '5G Wi-Fi',
          screenTimeMinutesToday: data['screenTimeTodayMinutes'] ?? 142,
          currentApp: data['activeApp'] ?? 'YouTube',
        );
      }
    } catch (e) {
      print('[DeviceRepository Error] $e');
    }
    return ChildDevice(childId: childId, name: 'Alex Jenkins', deviceName: "Samsung S24 Ultra", isOnline: true, batteryLevel: 78, isCharging: true, temperature: 34.8, networkType: '5G Wi-Fi', screenTimeMinutesToday: 142, currentApp: 'YouTube');
  }

  Future<List<AppUsageItem>> fetchAppUsages() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/device/app-usage'));
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
    return [
      AppUsageItem(packageName: 'com.zhiliaoapp.musically', appName: 'TikTok', category: 'Social', minutesUsed: 75, isBlocked: false, dailyLimitMinutes: 60),
      AppUsageItem(packageName: 'com.google.android.youtube', appName: 'YouTube', category: 'Video', minutesUsed: 52, isBlocked: false, dailyLimitMinutes: 90),
    ];
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
