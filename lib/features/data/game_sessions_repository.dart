

import 'package:brick_breaker/features/services/game_sessions_api_services.dart';
import 'package:brick_breaker/modals/game_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameSessionsRepositoryProvider = Provider<GameSessionsRepository>((ref) {
  final gameSessionsAPIService = ref.read(gameSessionsAPIServiceProvider);
  return GameSessionsRepository(gameSessionsAPIService);
});

class GameSessionsRepository {
  GameSessionsRepository(this.gameSessionsAPIService);

  final GameSessionsAPIService gameSessionsAPIService;

  Future<List<GameSession>> getGameSessions() {
    return gameSessionsAPIService.getGameSessions();
  }

  Future<void> add(GameSession gameSession) async {
    return gameSessionsAPIService.addGameSession(gameSession);
  }
}