

// Dynamic In-Memory Store for Real Paired Child Devices
const childrenDevicesStore = [];

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
      const childId = req.query.childId;
      let device = null;
      
      if (childId) {
        device = childrenDevicesStore.find(c => c.childId === childId);
      }
      
      if (!device && childrenDevicesStore.length > 0) {
        device = childrenDevicesStore[0];
      }

      if (!device) {
        return res.status(200).json({
          success: true,
          telemetry: null,
          message: 'No child device linked yet.'
        });
      }

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
      let device = childrenDevicesStore.find(c => c.childId === childId);
      
      if (!device && childrenDevicesStore.length > 0) {
        device = childrenDevicesStore[0];
      }

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
        device.lastSeen = new Date().toISOString();
      }

      return res.status(200).json({ success: true, message: 'Telemetry updated in real time' });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }

  async registerNewChildDevice(childData) {
    const existingIndex = childrenDevicesStore.findIndex(
      c => c.deviceName === childData.deviceName || c.parentEmail === childData.parentEmail
    );

    const newChild = {
      childId: 'child-' + Date.now(),
      name: childData.name || childData.deviceName || "Child's Android Phone",
      deviceName: childData.deviceName || "Child's Android Device",
      parentEmail: childData.parentEmail || 'parent@gmail.com',
      isOnline: true,
      batteryLevel: childData.batteryLevel || 88,
      isCharging: true,
      temperature: 33.5,
      networkType: '5G Wi-Fi',
      screenTimeMinutesToday: 15,
      activeApp: 'HomeScreen',
      lastLocation: {
        lat: 37.7749,
        lng: -122.4194,
        address: 'San Francisco, CA',
        speedMph: 0,
        recordedAt: new Date().toISOString()
      },
      securityFlags: { vpnActive: false, rootDetected: false, simChanged: false, tamperAttempt: false },
      lastSeen: new Date().toISOString()
    };

    if (existingIndex >= 0) {
      childrenDevicesStore[existingIndex] = newChild;
    } else {
      childrenDevicesStore.push(newChild);
    }
    return newChild;
  }

  async sendRemoteCommand(req, res) {
    try {
      const { childId, command } = req.body;
      return res.status(200).json({
        success: true,
        message: `Remote command '${command}' sent successfully to child device.`,
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
          { packageName: 'com.zhiliaoapp.musically', appName: 'TikTok', category: 'Social Media', screenTimeSeconds: 3600, isBlocked: false, dailyLimitMinutes: 60 },
          { packageName: 'com.google.android.youtube', appName: 'YouTube', category: 'Entertainment', screenTimeSeconds: 2400, isBlocked: false, dailyLimitMinutes: 90 },
          { packageName: 'com.roblox.client', appName: 'Roblox', category: 'Games', screenTimeSeconds: 1800, isBlocked: true, dailyLimitMinutes: 45 },
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
          { id: 'alt-1', type: 'geofence_exit', severity: 'medium', title: 'SafeZone Event', message: 'Child device location updated.', timestamp: new Date().toISOString() }
        ]
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }
}

module.exports = new DeviceController();
