import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';
import '../repositories/device_repository.dart';
import '../repositories/ai_repository.dart';
import '../repositories/auth_repository.dart';

final apiServiceProvider = Provider((ref) => ApiService());
final socketServiceProvider = Provider((ref) => SocketService());
final deviceRepositoryProvider = Provider((ref) => DeviceRepository());
final aiRepositoryProvider = Provider((ref) => AIRepository());
final authRepositoryProvider = Provider((ref) => AuthRepository());

final familyChildrenProvider = FutureProvider<List<ChildDevice>>((ref) async {
  final repo = ref.watch(deviceRepositoryProvider);
  return repo.fetchFamilyChildren();
});

final selectedChildIdProvider = StateProvider<String>((ref) => 'child-5501');

final childTelemetryProvider = FutureProvider<ChildDevice>((ref) async {
  final repo = ref.watch(deviceRepositoryProvider);
  final childId = ref.watch(selectedChildIdProvider);
  return repo.fetchTelemetry(childId: childId);
});

final currentLocationProvider = FutureProvider<LocationPoint>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchCurrentLocation();
});

final appUsagesProvider = FutureProvider<List<AppUsageItem>>((ref) async {
  final repo = ref.watch(deviceRepositoryProvider);
  return repo.fetchAppUsages();
});

final alertsProvider = FutureProvider<List<SecurityAlertItem>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchAlerts();
});

class AIChatNotifier extends StateNotifier<List<AIChatMessage>> {
  final AIRepository aiRepo;
  AIChatNotifier(this.aiRepo)
      : super([
          AIChatMessage(
            sender: 'ai',
            text: 'Hello! I am GuardianX AI Assistant. Ask me anything about Alex or Maya\'s screen time, location, or app usage.',
            time: DateTime.now(),
          )
        ]);

  Future<void> sendMessage(String text) async {
    state = [
      ...state,
      AIChatMessage(sender: 'user', text: text, time: DateTime.now())
    ];

    final reply = await aiRepo.queryAI(text);

    state = [
      ...state,
      AIChatMessage(sender: 'ai', text: reply, time: DateTime.now())
    ];
  }
}

final aiChatProvider = StateNotifierProvider<AIChatNotifier, List<AIChatMessage>>((ref) {
  final aiRepo = ref.watch(aiRepositoryProvider);
  return AIChatNotifier(aiRepo);
});
