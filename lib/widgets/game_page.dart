
import 'package:brick_breaker/bricks_breaker.dart';
import 'package:brick_breaker/game_manager/game_manager.dart';
import 'package:brick_breaker/widgets/game_over.dart';
import 'package:brick_breaker/widgets/game_pause.dart';
import 'package:brick_breaker/widgets/game_top_bar.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.title});
  final String title;
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game game = BricksBreaker();
  final GameManager gameManager = GameManager();
  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Lottie animation as the background
              Positioned.fill(
                child: Lottie.asset(
                  'assets/lottie/gradient.json',
                  fit: BoxFit.cover,
                ),
              ),
              // Board and other widgets on top
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  GameTopBar(
                    game: game,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Stack(
                      children: [
                        // Game board
                        GameWidget(
                          game: game,
                          overlayBuilderMap: <String,
                              Widget Function(BuildContext, Game)>{
                            'gameOverOverlay': (context, game) => GameOver(
                                  game: game,
                                  gameManager: gameManager,
                                ),
                            'gamePauseOverlay': (context, game) => GamePause(
                                  game: game,
                                ),
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
