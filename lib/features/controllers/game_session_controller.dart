import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:brick_breaker/features/data/game_sessions_repository.dart';
import 'package:brick_breaker/modals/game_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'game_session_controller.g.dart';

@riverpod
class GameSessionsController extends _$GameSessionsController {
  Future<List<GameSession>> _fetchGameSessions() async {
    final gameSessionsRepository = ref.read(gameSessionsRepositoryProvider);
    final gameSessions = await gameSessionsRepository.getGameSessions();
    return gameSessions;
  }

  @override
  FutureOr<List<GameSession>> build() async {
    return _fetchGameSessions();
  }

  storeHighestScore(String score) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? scr = await getScore();
    final scrInt = int.parse(scr ?? "0");
    if (scrInt > int.parse(score)) {
      await prefs.setString('score', score);
    }
  }

  Future<String?> getScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('score');
  }

  Future<void> addGameSession({
    required int score,
  }) async {
    final gameSession = GameSession(
      sessionDate: TemporalDate(DateTime.now()),
      sessionScore: score,
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final gameSessionsRepository = ref.read(gameSessionsRepositoryProvider);
      await gameSessionsRepository.add(gameSession);
      return _fetchGameSessions();
    });
  }

  Future<GameSession> getHighestScoreGameSession() async {
    final gameSessions = await _fetchGameSessions();
    final highestScoreGameSession = gameSessions.reduce(
        (currentGameSession, nextGameSession) =>
            currentGameSession.sessionScore > nextGameSession.sessionScore
                ? currentGameSession
                : nextGameSession);

    return highestScoreGameSession;
  }
}
