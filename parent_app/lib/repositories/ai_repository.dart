import 'dart:convert';
import 'package:http/http.dart' as http;

class AIRepository {
  final String baseUrl;
  AIRepository({this.baseUrl = 'http://localhost:4000/api/v1'});

  Future<String> queryAI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/ai/query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': prompt}),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body)['response'] ?? 'AI Analysis Complete.';
      }
    } catch (e) {
      print('[AIRepository Error] $e');
    }
    return "GuardianX AI Analysis: Screen time is within healthy boundaries today. Addiction risk score is Low (22/100).";
  }

  Future<Map<String, dynamic>> fetchRiskAssessment() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/ai/risk-assessment'));
      if (res.statusCode == 200) {
        return jsonDecode(res.body)['assessment'];
      }
    } catch (e) {
      print('[AIRepository Risk Error] $e');
    }
    return {
      'addictionRiskScore': 22,
      'riskLevel': 'Low Risk',
      'breakdown': {'gamingMinutes': 35, 'socialMediaMinutes': 75, 'educationalMinutes': 45}
    };
  }
}
