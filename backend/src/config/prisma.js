const { PrismaClient } = require('@prisma/client');

let prisma;
try {
  prisma = new PrismaClient();
} catch (e) {
  console.warn('[GuardianX Prisma] Initialized in standby mode.');
}

module.exports = prisma || {};
