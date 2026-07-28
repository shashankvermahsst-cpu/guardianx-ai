const deviceController = require('./deviceController');

class AuthController {
  async login(req, res) {
    try {
      const { email, password } = req.body;
      if (!email) {
        return res.status(400).json({ success: false, error: 'Email is required.' });
      }

      return res.status(200).json({
        success: true,
        message: 'Authentication successful',
        user: {
          id: 'usr-9901',
          email,
          fullName: email.split('@')[0],
          role: 'PARENT',
          familyId: 'fam-99001'
        }
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }

  async pairChildDevice(req, res) {
    try {
      const { pairingCode, deviceName, parentEmail } = req.body;

      if (!pairingCode) {
        return res.status(400).json({ success: false, error: 'Pairing code is required.' });
      }

      // Dynamically add new child device to multi-child store
      const newChild = await deviceController.registerNewChildDevice({
        name: deviceName || '2nd Child Device',
        deviceName: deviceName || "Child's Phone"
      });

      return res.status(200).json({
        success: true,
        message: '2nd Child device paired & synced with parent account!',
        childProfile: newChild
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }

  async generatePairingCode(req, res) {
    try {
      const code = 'GX-' + Math.floor(1000 + Math.random() * 9000);
      return res.status(200).json({
        success: true,
        pairCode: code,
        expiresInSeconds: 600
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }
}

module.exports = new AuthController();
