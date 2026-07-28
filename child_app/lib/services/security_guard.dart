import 'dart:async';

class SecurityGuard {
  static final SecurityGuard _instance = SecurityGuard._internal();
  factory SecurityGuard() => _instance;
  SecurityGuard._internal();

  bool isVpnActive = false;
  bool isRooted = false;
  bool isSimChanged = false;

  void startAntiTamperMonitoring(Function(String alertType, String message) onAlertTriggered) {
    Timer.periodic(const Duration(seconds: 15), (timer) {
      // 1. Check VPN status simulation
      if (isVpnActive) {
        onAlertTriggered('vpn_enabled', 'VPN bypass attempt intercepted by GuardianX Security Guard.');
      }

      // 2. Check Root status simulation
      if (isRooted) {
        onAlertTriggered('root_detected', 'Device root/jailbreak binaries detected on child hardware.');
      }
    });
  }
}
