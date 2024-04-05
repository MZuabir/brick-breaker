import 'package:brick_breaker/game_manager/game_manager.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScore extends StatelessWidget {
  const GameScore({
    super.key,
    required this.game,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: score,
      builder: (context, value, child) {
        return Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
