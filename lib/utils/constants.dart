import 'package:flutter/material.dart';

enum BallState {
  ideal,
  drag,
  release,
  completed,
}

const ballRadius = 15.0;

const ballColor = 0xFFFFFFFF;

const brickColor = 0xFF24998B;
const brickFontColor = 0xFFFFFFFF;
const brickFontSize = 20.0;

const numberOfBricksInRow = 8;
const brickPadding = 8;
const maxValueOfBrick = 10;
const minValueOfBrick = -5;

const panelColor = 0xFF1B1B1B;

const Color startButtonColor = Color.fromRGBO(235, 32, 93, 1);
const Color continueButtonColor = Color.fromRGBO(235, 32, 93, 1);
const Color restartButtonColor = Color.fromRGBO(243, 181, 45, 1);

const String gameTitle = 'The BricksBreaker Game';

const String brickRowRemoverText = '💣';
const String brickColumnRemoverText = '🧨';
const double powerUpProbability = 15;
const double powerUpAppleProbability = 20;
const double powerUpBallProbability = 25;

const String gift = '🎁';
const String apple = "🍎";
const String ballGift = "⚽";

const String brickRowRemoverAudio = 'row_explosion.mp3';
const String brickColumnRemoverAudio = 'column_explosion.mp3';
const String ballAudio = 'ball.mp3';
