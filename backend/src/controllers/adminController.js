// Admin Dashboard Metrics & Management Controller
class AdminController {
  async getDashboardStats(req, res) {
    try {
      return res.status(200).json({
        success: true,
        stats: {
          totalParents: 14280,
          activeChildDevices: 21950,
          monthlyRecurringRevenueUsd: 128400,
          securityInterceptions24h: 342,
          activeSubscriptions: {
            monthly: 8200,
            yearly: 4500,
            familyPlan: 1580
          },
          serverStatus: {
            cpuUsage: '14%',
            memoryUsage: '42%',
            socketConnections: 8940,
            dbLatencyMs: 4
          }
        }
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }

  async listUsers(req, res) {
    try {
      return res.status(200).json({
        success: true,
        users: [
          { id: 'usr-1', name: 'Sarah Jenkins', email: 'parent@guardianx.ai', plan: 'Family Plan', devicesCount: 2, status: 'Active', joinedDate: '2026-01-15' },
          { id: 'usr-2', name: 'Michael Vance', email: 'm.vance@example.com', plan: 'Yearly Pro', devicesCount: 1, status: 'Active', joinedDate: '2026-02-10' },
          { id: 'usr-3', name: 'Elena Rostova', email: 'elena.r@example.org', plan: 'Monthly', devicesCount: 3, status: 'Active', joinedDate: '2026-03-22' }
        ]
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }
}

module.exports = new AdminController();
