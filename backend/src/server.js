require('dotenv').config();
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');
const helmet = require('helmet');
const apiRoutes = require('./routes/api');
const setupSocketHandlers = require('./services/socketHandler');

const app = express();
const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

// Middleware
app.use(helmet({ contentSecurityPolicy: false }));
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Root Health & Landing Route
app.get('/', (req, res) => {
  res.status(200).send(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>GuardianX AI Engine</title>
        <style>
          body { background: #0F0C20; color: white; font-family: system-ui, -apple-system, sans-serif; text-align: center; padding: 60px 20px; }
          .card { background: #1B1736; max-width: 500px; margin: 0 auto; padding: 30px; border-radius: 20px; border: 1px solid #6C5CE7; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
          h1 { color: #00CEC9; margin-bottom: 10px; }
          .badge { background: #2ED573; color: black; padding: 6px 14px; border-radius: 20px; font-weight: bold; font-size: 13px; display: inline-block; }
          a { color: #00CEC9; text-decoration: none; font-weight: bold; }
        </style>
      </head>
      <body>
        <div class="card">
          <h1>🛡️ GuardianX AI Engine</h1>
          <p style="color: #A0A0B2;">Protect. Monitor. Guide. Production Mode Active</p>
          <div class="badge">● SERVER ONLINE (24/7 LIVE)</div>
          <hr style="border: 0; border-top: 1px solid #ffffff1a; margin: 20px 0;" />
          <p><a href="/api/v1/health">Test Health API Endpoint (/api/v1/health)</a></p>
        </div>
      </body>
    </html>
  `);
});

// REST API Router
app.use('/api/v1', apiRoutes);

// Socket.IO Setup
setupSocketHandlers(io);

// Server Listening
const PORT = process.env.PORT || 4000;
server.listen(PORT, () => {
  console.log(`====================================================`);
  console.log(`🚀 GuardianX AI Server Running on Port ${PORT}`);
  console.log(`🛡️  Protect. Monitor. Guide. Production Mode Active`);
  console.log(`====================================================`);
});
