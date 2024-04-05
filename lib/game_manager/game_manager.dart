import 'package:brick_breaker/bricks_breaker.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

ValueNotifier<int> score = ValueNotifier(0);

class GameManager extends Component with HasGameRef<BricksBreaker> {
  GameManager();

  GameState state = GameState.intro;
  void reset() {
    state = GameState.intro;
    score.value = 0;
  }

  void increaseScore() {
    score.value++;
  }

  void increaseScoreBy5() {
    score.value = score.value + 5;
  }
}

enum GameState { intro, playing, gameOver }
