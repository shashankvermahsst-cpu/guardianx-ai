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
