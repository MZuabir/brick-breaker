import 'dart:async';
import 'dart:math' as math;

import 'package:brick_breaker/bloc/inventory_bloc/inventory_bloc.dart';
import 'package:brick_breaker/bloc/inventory_bloc/inventory_bloc_state.dart';
import 'package:brick_breaker/components/ball.dart';
import 'package:brick_breaker/components/board.dart';
import 'package:brick_breaker/components/brick.dart';
import 'package:brick_breaker/game_manager/game_manager.dart';
import 'package:brick_breaker/utils/constants.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class BricksBreaker extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  BricksBreaker({super.children});

  Timer timer = Timer(const Duration(seconds: 1), () {});
  final GameManager gameManager = GameManager();
  final Ball ball = Ball();
  final Board board = Board();
  int numberOfBricksLayer = 3;
  final math.Random _random = math.Random();
  List<Ball> giftedBals = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      FlameBlocProvider<InventoryBloc, InventoryState>(
        create: () => InventoryBloc(),
        children: [gameManager, board, ball],
      ),
    );

    await add(gameManager);
    ball.priority = 1;
    addAll([board, ball]);
    addAll(giftedBals);

    loadInitialBrickLayer();
  }

  void resetGame() {
    if (timer.isActive) timer.cancel();
    if (giftedBals.isNotEmpty) removeAll(giftedBals);
    pauseEngine();
    overlays.remove('gamePauseOverlay');
    overlays.remove('gameOverOverlay');
    giftedBals.clear();
    // priorities.clear();

    children.whereType<Brick>().forEach((brick) {
      brick.removeFromParent();
    });

    gameManager.reset();

    ball.resetBall();
    board.resetBoard();
    resumeEngine();

    numberOfBricksLayer = 3;
    loadInitialBrickLayer();
  }

  int generateFourOrMinusFour() {
    math.Random random = math.Random();
    return random.nextBool() ? 4 : -4;
  }

  int generateRandomNumber() {
    math.Random random = math.Random();
    return random.nextInt(5) + 1;
  }

  void togglePauseState() {
    if (paused) {
      overlays.remove('gamePauseOverlay');
      resumeEngine();
    } else {
      if (timer.isActive) timer.cancel();
      overlays.add('gamePauseOverlay');
      pauseEngine();
    }
  }

  double get brickSize {
    const totalPadding = (numberOfBricksInRow + 1) * brickPadding;
    final screenMinSize = size.x < size.y ? size.x : size.y;
    return (screenMinSize - totalPadding) / numberOfBricksInRow;
  }

  int next(int min, int max) => min + _random.nextInt(max);

  List<Brick> generateBrickLayer(int row) {
    return List<Brick>.generate(
      numberOfBricksInRow,
      (index) => Brick(
        brickValue: next(minValueOfBrick, maxValueOfBrick).toInt(),
        size: brickSize,
        brickRow: row,
        brickColumn: index,
      ),
    );
  }

  Future<void> loadInitialBrickLayer() async {
    for (var row = 0; row < numberOfBricksLayer; row++) {
      final bricksLayer = generateBrickLayer(row);
      for (var i = 0; i < numberOfBricksInRow; i++) {
        final xPosition = i == 0
            ? 8
            : bricksLayer[i - 1].position.x + bricksLayer[i - 1].size.x + 8;
        final yPosition = (row + 1) * (brickSize + 8);

        await add(
          bricksLayer[i]..position = Vector2(xPosition.toDouble(), yPosition),
        );
      }
    }
  }

  addGiftScores() {
    gameManager.increaseScoreBy5();
  }

  Future<void> removeBrickLayerRow(int row) async {
    final bricksToRemove = children
        .whereType<Brick>()
        .toList()
        .where((element) => element.brickRow == row);

    for (final brick in bricksToRemove) {
      brick.removeFromParent();
    }
    gameManager.increaseScoreBy5();
  }

  Future<void> removeBrickLayerColumn(int column) async {
    final bricksToRemove = children
        .whereType<Brick>()
        .toList()
        .where((element) => element.brickColumn == column);

    for (final brick in bricksToRemove) {
      brick.removeFromParent();
    }
    gameManager.increaseScoreBy5();
  }

  @override
  Future<void> update(double dt) async {
    final brickComponents = children.whereType<Brick>().toList();
    if (ball.ballState == BallState.completed || brickComponents.isEmpty) {
      await updateBrickPositions();
    }

    for (final giftedBall in giftedBals) {
      giftedBall.moveGiftedBall(dt);
    }

    super.update(dt);
  }

  Future<void> updateBrickPositions() async {
    final brickComponents = children.whereType<Brick>().toList();

    for (final brick in brickComponents) {
      final nextYPosition = brick.position.y + brickSize + 8;
      if (board.size.y - ball.size.y <= nextYPosition + brick.size.y - 10) {
        if (!(ball.isColliding)) {
          pauseEngine();

          gameManager.state = GameState.gameOver;
          ball.ballState = BallState.ideal;
        
          overlays.add('gameOverOverlay');
        }
      }
      brick.position.y = nextYPosition;
    }

    List<Brick> bricksLayer = [];
    do {
      bricksLayer = generateBrickLayer(numberOfBricksLayer);
    } while (bricksLayer.length < 5); // Ensure at least 5 bricks in the layer

    for (var i = 0; i < 7; i++) {
      await add(
        bricksLayer[i % bricksLayer.length] // Repeat the bricks if needed
          ..position = Vector2(
            i == 0
                ? 8
                : bricksLayer[i - 1].position.x + bricksLayer[i - 1].size.x + 8,
            brickSize + 8,
          ),
      );
    }
    numberOfBricksLayer++;

    ball.ballState = BallState.ideal;
    gameManager.increaseScore();
  }

  void increaseBallSpeed() {
    ball.increaseSpeed();
  }

  void addGiftBall() {
    final Ball newBall = Ball();
    newBall.setColor(Colors.red);
    newBall.xDirection = 1;
    newBall.yDirection = -1;
    newBall.speed = 5;
    giftedBals.add(newBall);
    add(newBall);
    newBall.giftedBallNextPosition = Vector2(
        generateFourOrMinusFour().toDouble(),
        generateRandomNumber().toDouble());
    newBall.ballState = BallState.release;
    timer = Timer(const Duration(seconds: 3), () {
      remove(giftedBals.first);
      giftedBals.remove(giftedBals.first);
    });
    print(
        "Added gifted ball with next position: ${newBall.giftedBallNextPosition}");
  }
}
