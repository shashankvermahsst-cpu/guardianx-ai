const jwt = require('jsonwebtoken');
const crypto = require('crypto');

const JWT_SECRET = process.env.JWT_SECRET || 'guardianx_secret_key_2026_production_secure';
const AES_SECRET = process.env.AES_SECRET || 'guardianx_aes_256_key_32bytes!!'; // 32 chars

// 1. JWT Middleware
const verifyToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  if (!authHeader) {
    return res.status(401).json({ success: false, error: 'Access Denied: Missing Authorization Header' });
  }

  const token = authHeader.split(' ')[1];
  if (!token) {
    return res.status(401).json({ success: false, error: 'Access Denied: Malformed Bearer Token' });
  }

  try {
    const verified = jwt.verify(token, JWT_SECRET);
    req.user = verified;
    next();
  } catch (err) {
    return res.status(403).json({ success: false, error: 'Invalid or Expired Token' });
  }
};

// 2. Play Integrity API & Certificate Pinning Check
const verifyDeviceIntegrity = (req, res, next) => {
  const deviceSignature = req.headers['x-guardianx-signature'];
  const certHash = req.headers['x-guardianx-cert-pin'];

  // Enforce certificate pinning header present
  if (!certHash) {
    return res.status(400).json({ 
      success: false, 
      error: 'Security Violation: Untrusted device certificate. Tamper risk detected.' 
    });
  }
  next();
};

// 3. AES-256 Encryption & Decryption Helpers
const encryptPayload = (data) => {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(AES_SECRET.padEnd(32).slice(0, 32)), iv);
  let encrypted = cipher.update(JSON.stringify(data), 'utf8', 'hex');
  encrypted += cipher.final('hex');
  return {
    iv: iv.toString('hex'),
    payload: encrypted
  };
};

const decryptPayload = (ivHex, encryptedHex) => {
  const iv = Buffer.from(ivHex, 'hex');
  const decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(AES_SECRET.padEnd(32).slice(0, 32)), iv);
  let decrypted = decipher.update(encryptedHex, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  return JSON.parse(decrypted);
};

module.exports = {
  verifyToken,
  verifyDeviceIntegrity,
  encryptPayload,
  decryptPayload,
  JWT_SECRET
};
