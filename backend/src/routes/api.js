const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const deviceController = require('../controllers/deviceController');
const aiController = require('../controllers/aiController');
const adminController = require('../controllers/adminController');

// Health Check Endpoint
router.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ONLINE',
    app: 'GuardianX AI Backend Engine',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

// Authentication & Session Routes
router.post('/auth/login', authController.login);
router.post('/auth/generate-pair-code', authController.generatePairingCode);
router.post('/auth/pair-child', authController.pairChildDevice);

// Family & Multi-Child Devices
router.get('/family/children', deviceController.getFamilyChildren);

// Device & Telemetry Routes
router.get('/device/telemetry', deviceController.getDeviceTelemetry);
router.post('/device/telemetry-update', deviceController.updateTelemetry);
router.post('/device/remote-command', deviceController.sendRemoteCommand);
router.get('/device/app-usage', deviceController.getAppUsages);
router.post('/device/app-rules', deviceController.updateAppRule);
router.get('/device/alerts', deviceController.getAlerts);

// AI Engine Routes
router.post('/ai/query', aiController.askAssistant);
router.get('/ai/risk-assessment', aiController.getRiskAssessment);

// Admin Dashboard Routes
router.get('/admin/stats', adminController.getDashboardStats);
router.get('/admin/users', adminController.listUsers);

module.exports = router;
