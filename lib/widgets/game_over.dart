
import 'package:brick_breaker/bricks_breaker.dart';
import 'package:brick_breaker/features/controllers/game_session_controller.dart';
import 'package:brick_breaker/features/ui/game_sessions_highest_score.dart';
import 'package:brick_breaker/game_manager/game_manager.dart';
import 'package:brick_breaker/utils/constants.dart';
import 'package:brick_breaker/widgets/game_button.dart';
import 'package:brick_breaker/widgets/game_score.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameOver extends StatefulWidget {
  const GameOver({
    super.key,
    required this.game,
    required this.gameManager,
  });

  final Game game;
  final GameManager gameManager;

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  @override
  void initState() {
    super.initState();
  }

  setScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? scr = prefs.getString('score');

    final scrInt = int.parse(scr ?? "0");

    if (scrInt < score.value) {
      await prefs.setString('score', score.value.toString());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .update({"score": score.value.toString()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Lottie.asset(
          'assets/lottie/gradient.json',
          fit: BoxFit.fill,
          width: double.infinity,
        ),
        Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Consumer(builder: (context, ref, child) {
                  Future(() {
                    ref
                        .watch(gameSessionsControllerProvider.notifier)
                        .addGameSession(
                          score: score.value,
                        );
                  });

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text(
                          'GAME OVER',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'SCORE',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      GameScore(
                        game: widget.game,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'HIGHEST SCORE',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const GameHighestScore(),
                      const SizedBox(height: 20),
                      GameButton(
                        onPressed: () async {
                          await setScore();
                          (widget.game as BricksBreaker).resetGame();
                       
                        },
                        title: 'TRY AGAIN',
                        color: continueButtonColor,
                        width: 200,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }),
              ),
            )
          ],
        )
      ],
    );
  }
}
