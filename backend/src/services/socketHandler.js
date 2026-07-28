// GuardianX Socket.IO Realtime Engine

const setupSocketHandlers = (io) => {
  io.on('connection', (socket) => {
    console.log(`[GuardianX Socket] Client connected: ${socket.id}`);

    // Join family room for encrypted broadcasts
    socket.on('join_family', ({ familyId, role }) => {
      const room = `family_${familyId}`;
      socket.join(room);
      console.log(`[Socket] ${role} joined room ${room}`);
      socket.emit('joined_room', { room, success: true });
    });

    // 1. Child Device Telemetry Stream
    socket.on('telemetry_update', (data) => {
      const { familyId, childId, battery, temperature, network, isCharging, isOnline } = data;
      // Broadcast to parent devices in family room
      io.to(`family_${familyId}`).emit('parent_telemetry_feed', {
        childId,
        battery,
        temperature,
        network,
        isCharging,
        isOnline,
        timestamp: new Date().toISOString()
      });
    });

    // 2. Real-Time GPS Tracking & GeoFence Alerts
    socket.on('location_update', (data) => {
      const { familyId, childId, lat, lng, speed, address } = data;
      io.to(`family_${familyId}`).emit('parent_location_feed', {
        childId,
        lat,
        lng,
        speed,
        address,
        timestamp: new Date().toISOString()
      });
    });

    // 3. Screen Mirroring Stream Relay
    socket.on('screen_frame_chunk', (data) => {
      const { familyId, frameBase64, quality } = data;
      socket.to(`family_${familyId}`).emit('parent_screen_frame', {
        frameBase64,
        quality,
        timestamp: new Date().toISOString()
      });
    });

    socket.on('control_screen_mirror', (data) => {
      const { childId, action } = data; // 'start', 'pause', 'resume', 'stop'
      io.emit(`child_screen_command_${childId}`, { action });
    });

    // 4. Remote Camera Stream & Snapshot Command
    socket.on('request_camera_snapshot', (data) => {
      const { childId, cameraType } = data; // 'front' or 'rear'
      io.emit(`child_camera_capture_${childId}`, { cameraType, silent: true });
    });

    socket.on('camera_snapshot_result', (data) => {
      const { familyId, imageBase64, cameraType } = data;
      io.to(`family_${familyId}`).emit('parent_camera_feed', {
        imageBase64,
        cameraType,
        timestamp: new Date().toISOString()
      });
    });

    // 5. Remote Audio Listener
    socket.on('request_audio_listen', (data) => {
      const { childId, durationSeconds } = data;
      io.emit(`child_audio_start_${childId}`, { durationSeconds });
    });

    socket.on('audio_chunk', (data) => {
      const { familyId, audioBase64 } = data;
      socket.to(`family_${familyId}`).emit('parent_audio_feed', { audioBase64 });
    });

    // 6. Instant Security Alert Trigger
    socket.on('trigger_security_alert', (data) => {
      const { familyId, childId, alertType, message, severity } = data;
      io.to(`family_${familyId}`).emit('parent_security_alert', {
        childId,
        alertType,
        message,
        severity,
        timestamp: new Date().toISOString()
      });
    });

    // 7. App Blocker Remote Lock Command
    socket.on('toggle_app_lock', (data) => {
      const { childId, packageName, isBlocked } = data;
      io.emit(`child_app_lock_${childId}`, { packageName, isBlocked });
    });

    socket.on('disconnect', () => {
      console.log(`[GuardianX Socket] Client disconnected: ${socket.id}`);
    });
  });
};

module.exports = setupSocketHandlers;
