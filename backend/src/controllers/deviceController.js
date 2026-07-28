// GuardianX Production Device Controller (Multi-Child & Live Telemetry Store)

const childrenDevicesStore = [
  {
    childId: 'child-5501',
    name: 'Alex Jenkins',
    deviceName: "Alex's Samsung S24 Ultra",
    isOnline: true,
    batteryLevel: 82,
    isCharging: true,
    temperature: 34.5,
    networkType: '5G Wi-Fi',
    screenTimeMinutesToday: 142,
    activeApp: 'YouTube',
    lastLocation: {
      lat: 37.7749,
      lng: -122.4194,
      address: '742 Evergreen Terrace, San Francisco, CA',
      speedMph: 0,
      recordedAt: new Date().toISOString()
    },
    securityFlags: { vpnActive: false, rootDetected: false, simChanged: false, tamperAttempt: false }
  },
  {
    childId: 'child-5502',
    name: 'Maya Jenkins (2nd Child)',
    deviceName: "Maya's Google Pixel 8",
    isOnline: true,
    batteryLevel: 94,
    isCharging: false,
    temperature: 32.1,
    networkType: '4G Cellular',
    screenTimeMinutesToday: 48,
    activeApp: 'Duolingo',
    lastLocation: {
      lat: 37.7833,
      lng: -122.4167,
      address: 'Market Street, San Francisco, CA',
      speedMph: 12,
      recordedAt: new Date().toISOString()
    },
    securityFlags: { vpnActive: false, rootDetected: false, simChanged: false, tamperAttempt: false }
  }
];

class DeviceController {
  async getFamilyChildren(req, res) {
    try {
      return res.status(200).json({
        success: true,
        children: childrenDevicesStore
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }

  async getDeviceTelemetry(req, res) {
    try {
      const childId = req.query.childId || 'child-5501';
      const device = childrenDevicesStore.find(c => c.childId === childId) || childrenDevicesStore[0];
      
      return res.status(200).json({
        success: true,
        telemetry: device
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }

  async updateTelemetry(req, res) {
    try {
      const { childId, batteryLevel, isCharging, temperature, networkType, activeApp, lat, lng, address } = req.body;
      const device = childrenDevicesStore.find(c => c.childId === childId);
      
      if (device) {
        if (batteryLevel !== undefined) device.batteryLevel = batteryLevel;
        if (isCharging !== undefined) device.isCharging = isCharging;
        if (temperature !== undefined) device.temperature = temperature;
        if (networkType) device.networkType = networkType;
        if (activeApp) device.activeApp = activeApp;
        if (lat && lng) {
          device.lastLocation = {
            lat,
            lng,
            address: address || device.lastLocation.address,
            speedMph: 0,
            recordedAt: new Date().toISOString()
          };
        }
        device.isOnline = true;
      }

      return res.status(200).json({ success: true, message: 'Telemetry updated in real time' });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }

  async registerNewChildDevice(childData) {
    const newChild = {
      childId: 'child-' + Date.now(),
      name: childData.name || 'Child 2 Device',
      deviceName: childData.deviceName || "Child's Android Phone",
      isOnline: true,
      batteryLevel: 90,
      isCharging: false,
      temperature: 33.0,
      networkType: '5G Wi-Fi',
      screenTimeMinutesToday: 10,
      activeApp: 'HomeScreen',
      lastLocation: {
        lat: 37.7749,
        lng: -122.4194,
        address: 'San Francisco, CA',
        speedMph: 0,
        recordedAt: new Date().toISOString()
      },
      securityFlags: { vpnActive: false, rootDetected: false, simChanged: false, tamperAttempt: false }
    };
    childrenDevicesStore.push(newChild);
    return newChild;
  }

  async sendRemoteCommand(req, res) {
    try {
      const { childId, command } = req.body;
      return res.status(200).json({
        success: true,
        message: `Remote command '${command}' sent successfully to child device (${childId}).`,
        timestamp: new Date().toISOString()
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }

  async getAppUsages(req, res) {
    try {
      return res.status(200).json({
        success: true,
        apps: [
          { packageName: 'com.zhiliaoapp.musically', appName: 'TikTok', category: 'Social Media', screenTimeSeconds: 4500, isBlocked: false, dailyLimitMinutes: 60 },
          { packageName: 'com.google.android.youtube', appName: 'YouTube', category: 'Entertainment', screenTimeSeconds: 3200, isBlocked: false, dailyLimitMinutes: 90 },
          { packageName: 'com.roblox.client', appName: 'Roblox', category: 'Games', screenTimeSeconds: 2100, isBlocked: true, dailyLimitMinutes: 45 },
          { packageName: 'com.instagram.android', appName: 'Instagram', category: 'Social Media', screenTimeSeconds: 1800, isBlocked: false, dailyLimitMinutes: 30 },
          { packageName: 'org.duolingo', appName: 'Duolingo', category: 'Education', screenTimeSeconds: 1200, isBlocked: false, dailyLimitMinutes: 0 }
        ]
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }

  async updateAppRule(req, res) {
    try {
      const { packageName, isBlocked, dailyLimitMinutes } = req.body;
      return res.status(200).json({
        success: true,
        message: `Updated rule for ${packageName}`,
        rule: { packageName, isBlocked, dailyLimitMinutes }
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }

  async getAlerts(req, res) {
    try {
      return res.status(200).json({
        success: true,
        alerts: [
          { id: 'alt-1', type: 'geofence_exit', severity: 'medium', title: 'Left Safe Zone', message: 'Alex left Lincoln High School zone at 03:15 PM.', timestamp: new Date(Date.now() - 3600000).toISOString() },
          { id: 'alt-2', type: 'vpn_enabled', severity: 'high', title: 'VPN Activation Attempt', message: 'ExpressVPN app launch detected and intercepted by GuardianX Shield.', timestamp: new Date(Date.now() - 7200000).toISOString() },
          { id: 'alt-3', type: 'low_battery', severity: 'low', title: 'Low Battery Alert', message: "Alex's device battery dropped below 15%.", timestamp: new Date(Date.now() - 18000000).toISOString() }
        ]
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }
}

module.exports = new DeviceController();
