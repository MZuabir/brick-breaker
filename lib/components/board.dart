import 'dart:math';

import 'package:brick_breaker/bricks_breaker.dart';
import 'package:brick_breaker/components/ball.dart';
import 'package:brick_breaker/utils/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Board extends RectangleComponent
    with DragCallbacks, HasGameRef<BricksBreaker> {
  Board()
      : super(
          paint: Paint()..color = const Color.fromARGB(255, 95, 180, 211),
        );

  // double dragLineSlope = 0;
  // final dragStartPosition = Vector2.zero();
  // final dragRelativePosition = Vector2.zero();
  final dividerPainter = Paint()
    ..color = Colors.orange
    ..style = PaintingStyle.fill;
  late final Path dividerPath;
  // late final Vector2 centerPosition;
  Ball ball = Ball();

  @override
  Future<void> onLoad() async {
    ball.centerPosition = position + (size / 2);
    size = Vector2(gameRef.size.x, gameRef.size.y);
    await add(RectangleHitbox());
    dividerPath = createDividerPath();
    // centerPosition = position + (size / 2);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPath(dividerPath, dividerPainter);
    super.render(canvas);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _handleDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isBallInIdealOrDragState()) {
      _updateDragRelatedParameters(event);
      gameRef.ball.priority = 1;
    }
  }

  Path createDividerPath() {
    return Path()
      ..addRect(Rect.fromLTWH(0, -2, size.x, 2)) // Top divider
      ..addRect(Rect.fromLTWH(0, size.y, size.x, 2)) // Bottom divider
      ..addRect(Rect.fromLTWH(-2, 0, 2, size.y)) // Left divider
      ..addRect(Rect.fromLTWH(size.x - 2, 0, 2, size.y)); // Right divider
  }

  _handleDragStart(DragStartEvent event) {
    if (gameRef.ball.ballState == BallState.ideal) {
      ball.dragStartPosition.setFrom(event.localPosition);
    }
  }

  bool isBallInIdealOrDragState() {
    return gameRef.ball.ballState == BallState.ideal ||
        gameRef.ball.ballState == BallState.drag;
  }

  void _updateDragRelatedParameters(DragUpdateEvent event) {
    ball.dragRelativePosition
        .setFrom(event.localPosition - ball.dragStartPosition);

    final absolutePosition = (event.localPosition - ball.dragStartPosition)
      ..absolute();
    final isValid = absolutePosition.x > 15 || absolutePosition.y > 15;

    if (!ball.dragRelativePosition.y.isNegative && isValid) {
      gameRef.ball.ballState = BallState.drag;
      ball.dragLineSlope =
          ball.dragRelativePosition.y / ball.dragRelativePosition.x;
      final sign = ball.dragRelativePosition.x.sign == 0
          ? 1
          : ball.dragRelativePosition.x.sign;
      gameRef.ball.aimAngle =
          atan(ball.dragLineSlope) - sign * 90 * degrees2Radians;
    } else {
      gameRef.ball.ballState = BallState.ideal;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (gameRef.ball.ballState == BallState.drag &&
        !ball.dragRelativePosition.y.isNegative) {
      _handleDragEnd();
    }

    super.onDragEnd(event);
    priority = 0;
  }

  _handleDragEnd() {
    gameRef.ball.xDirection = ball.dragRelativePosition.x.sign * -1;
    gameRef.ball.yDirection = -1;
    final newPosition = getNextPosition();
    gameRef.ball.nextPosition.setFrom(newPosition);

    if (gameRef.ball.ballState != BallState.release) {
      gameRef.ball.aimAngle = 0;
      gameRef.ball.ballState = BallState.release;
    }
  }

  Vector2 getNextPosition() {
    var newPointX = 0.0;
    var newPointY = 0.0;

    if (ball.dragLineSlope > -1 && ball.dragLineSlope < 1) {
      newPointX = ball.centerPosition.x - ball.dragLineSlope.sign * 5;
      newPointY = ball.centerPosition.y +
          (ball.dragLineSlope * (newPointX - ball.centerPosition.x));
    } else {
      newPointY = ball.centerPosition.y - 5;
      newPointX = (newPointY - ball.centerPosition.y) / ball.dragLineSlope +
          ball.centerPosition.x;
    }

    return Vector2(
      ball.dragLineSlope.sign * (ball.centerPosition.x - newPointX),
      ball.centerPosition.y - newPointY,
    );
  }

  void resetBoard() {
    ball.dragLineSlope = 0;
    ball.dragStartPosition.setZero();
    ball.dragRelativePosition.setZero();
    gameRef.ball.ballState = BallState.ideal;
  }
}
