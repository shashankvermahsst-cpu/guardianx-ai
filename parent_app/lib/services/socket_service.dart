import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SocketService {
  final String baseUrl;
  SocketService({this.baseUrl = 'https://guardianx-ai-0d9y.onrender.com'});

  StreamController<Map<String, dynamic>> telemetryStreamController = StreamController.broadcast();
  StreamController<Map<String, dynamic>> locationStreamController = StreamController.broadcast();
  StreamController<Map<String, dynamic>> cameraStreamController = StreamController.broadcast();
  StreamController<Map<String, dynamic>> alertStreamController = StreamController.broadcast();

  void initSocketConnection(String familyId) {
    print('[SocketService] Realtime WebSocket tunnel initiated for family: $familyId on $baseUrl');
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final res = await http.get(Uri.parse('$baseUrl/api/v1/device/telemetry'));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body)['telemetry'];
          telemetryStreamController.add(data);
          if (data['lastLocation'] != null) {
            locationStreamController.add(data['lastLocation']);
          }
        }
      } catch (e) {
        // Silently handle offline retry
      }
    });
  }

  Future<bool> sendRemoteCommand(String childId, String command) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/v1/device/remote-command'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'childId': childId, 'command': command}),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    telemetryStreamController.close();
    locationStreamController.close();
    cameraStreamController.close();
    alertStreamController.close();
  }
}
