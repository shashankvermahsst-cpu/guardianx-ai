class ChildDevice {
  final String childId;
  final String name;
  final String deviceName;
  final bool isOnline;
  final int batteryLevel;
  final bool isCharging;
  final double temperature;
  final String networkType;
  final int screenTimeMinutesToday;
  final String currentApp;

  ChildDevice({
    required this.childId,
    required this.name,
    required this.deviceName,
    required this.isOnline,
    required this.batteryLevel,
    required this.isCharging,
    required this.temperature,
    required this.networkType,
    required this.screenTimeMinutesToday,
    required this.currentApp,
  });
}

class LocationPoint {
  final double lat;
  final double lng;
  final String address;
  final double speedMph;
  final DateTime timestamp;

  LocationPoint({
    required this.lat,
    required this.lng,
    required this.address,
    required this.speedMph,
    required this.timestamp,
  });
}

class AppUsageItem {
  final String packageName;
  final String appName;
  final String category;
  final int minutesUsed;
  bool isBlocked;
  int dailyLimitMinutes;

  AppUsageItem({
    required this.packageName,
    required this.appName,
    required this.category,
    required this.minutesUsed,
    required this.isBlocked,
    required this.dailyLimitMinutes,
  });
}

class SecurityAlertItem {
  final String id;
  final String title;
  final String message;
  final String severity;
  final DateTime timestamp;

  SecurityAlertItem({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
  });
}

class AIChatMessage {
  final String sender; // 'user' or 'ai'
  final String text;
  final DateTime time;

  AIChatMessage({
    required this.sender,
    required this.text,
    required this.time,
  });
}
