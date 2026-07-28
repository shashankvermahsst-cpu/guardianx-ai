const aiEngine = require('../services/aiEngine');

class AIController {
  async askAssistant(req, res) {
    try {
      const { query } = req.body;
      if (!query) {
        return res.status(400).json({ success: false, error: 'Query text is required.' });
      }

      const sampleUsage = [
        { app_name: 'YouTube', screen_time_seconds: 3600, category: 'Entertainment' },
        { app_name: 'TikTok', screen_time_seconds: 4500, category: 'Social' }
      ];

      const aiResponse = await aiEngine.handleParentQuery(query, null, sampleUsage, null);

      return res.status(200).json({
        success: true,
        query,
        response: aiResponse.answer,
        confidence: aiResponse.confidence,
        timestamp: new Date().toISOString()
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }

  async getRiskAssessment(req, res) {
    try {
      const sampleUsage = [
        { app_name: 'TikTok', screen_time_seconds: 5400, category: 'Social Media' },
        { app_name: 'YouTube', screen_time_seconds: 3600, category: 'Entertainment' },
        { app_name: 'Roblox', screen_time_seconds: 2700, category: 'Games' }
      ];

      const assessment = aiEngine.calculateRiskAssessment(sampleUsage, 1, 0);

      return res.status(200).json({
        success: true,
        assessment
      });
    } catch (err) {
      return res.status(500).json({ success: false, error: err.message });
    }
  }
}

module.exports = new AIController();
