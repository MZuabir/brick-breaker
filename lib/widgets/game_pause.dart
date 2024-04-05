import 'package:brick_breaker/bricks_breaker.dart';
import 'package:brick_breaker/leader_board_screen.dart';
import 'package:brick_breaker/login_screen.dart';
import 'package:brick_breaker/utils/constants.dart';
import 'package:brick_breaker/widgets/game_button.dart';
import 'package:brick_breaker/widgets/game_score.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class GamePause extends StatelessWidget {
  const GamePause({
    super.key,
    required this.game,
  });

  final Game game;

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
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: Text(
                        'PAUSE',
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
                      game: game,
                    ),
                    const SizedBox(height: 20),
                    GameButton(
                      onPressed: () {
                        (game as BricksBreaker).togglePauseState();
                      },
                      title: 'CONTINUE',
                      color: continueButtonColor,
                      width: 200,
                    ),
                    const SizedBox(height: 10),
                    GameButton(
                      onPressed: () {
                        (game as BricksBreaker).resetGame();
                      },
                      title: 'RESTART',
                      color: restartButtonColor,
                      width: 200,
                    ),
                    const SizedBox(height: 10),
                    GameButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LeaderBoardScreen()));
                      },
                      title: 'Leader Board',
                      color: continueButtonColor,
                      width: 200,
                    ),
                    const SizedBox(height: 10),
                    GameButton(
                      onPressed: () {
                        GoogleSignIn().signOut();
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false);
                        });
                      },
                      title: 'Logout',
                      color: restartButtonColor,
                      width: 200,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
