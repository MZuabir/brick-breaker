import 'dart:math';
import 'dart:ui';
import 'package:brick_breaker/bricks_breaker.dart';
import 'package:brick_breaker/components/board.dart';
import 'package:brick_breaker/components/brick.dart';
import 'package:brick_breaker/utils/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Ball extends CircleComponent
    with HasGameRef<BricksBreaker>, CollisionCallbacks {
  Ball()
      : super(
          paint: Paint()..color = Colors.white,
          radius: ballRadius,
          // Vector2.all(ballRadius),

          children: [CircleHitbox()],
        );
  double dragLineSlope = 0;
  final dragStartPosition = Vector2.zero();
  final dragRelativePosition = Vector2.zero();
  Vector2 giftedBallNextPosition = Vector2.zero();
  late final Vector2 centerPosition;
  late Sprite sprite;

  BallState ballState = BallState.ideal;
  double speed = 2;

  static const degree = pi / 180;
  double xDirection = 0;
  double yDirection = 0;

  final nextPosition = Vector2.zero();

  double aimAngle = 0;
  Vector2 aimTriangleMidPoint = Vector2.zero();
  Vector2 aimTriangleBasePoint = Vector2.zero();
  List<Rect> aimPointerBalls = [];
  final aimPainter = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite("ball.png");
    centerPosition = position + (size / 2);
    resetBall();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Check if ball exceeds boundaries
    if (position.x < 0) {
      position.x = 0;
      // Reverse direction or handle collision with left boundary
      xDirection *= -1; //  Reverse horizontal direction
    } else if (position.x > gameRef.size.x - size.x) {
      position.x = gameRef.size.x - size.x;
      // Reverse direction or handle collision with right boundary
      xDirection *= -1; //  Reverse horizontal direction
    }

    if (position.y < 0) {
      position.y = 0;
      // Reverse direction or handle collision with top boundary
      yDirection *= -1; // Reverse vertical direction
    } else if (position.y > gameRef.size.y - size.y) {
      position.y = gameRef.size.y - size.y;
      // Reverse direction or handle collision with bottom boundary
      yDirection *= -1; //  Reverse vertical direction
    }

    if (position.y >= gameRef.board.size.y - size.y) {
      position.setFrom(
          Vector2(position.x, (gameRef.board.size.y - radius * 2) - 2));
      ballState = BallState.completed;
      speed = 2;
    }

    if (ballState == BallState.release) {
      moveBall(dt);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    sprite.render(canvas, size: Vector2.all(30));
    if (ballState == BallState.drag) {
      drawRotatedObject(
        canvas: canvas,
        center: Offset(size.x / 2, size.y / 2),
        angle: aimAngle,
        drawFunction: () => canvas.drawPath(aimPath, aimPainter),
      );
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    ballState = BallState.ideal;

    super.onCollisionStart(intersectionPoints, other);

    if (other is Board) {
      reflectFromBoard(intersectionPoints);
      ballState = BallState.release;
    } else if (other is Brick) {
      reflectFromBrick(intersectionPoints, other);
      ballState = BallState.release;
    } else if (other is Ball) {
      reflectFromBall(gameRef.ball, gameRef.giftedBals.first);
      ballState = BallState.release;
    }
  }

  void reflectFromBoard(Set<Vector2> intersectionPoints) {
    final isTopHit = intersectionPoints.first.y <= gameRef.board.position.y;
    final isLeftHit = intersectionPoints.first.x <= gameRef.board.position.x ||
        intersectionPoints.first.y <=
            gameRef.board.position.y + gameRef.board.size.y;
    final isRightHit = intersectionPoints.first.x >=
            gameRef.board.position.x + gameRef.board.size.x ||
        intersectionPoints.first.y <=
            gameRef.board.position.y + gameRef.board.size.y;

    if (isTopHit) {
      yDirection *= -1;
    } else if (isLeftHit || isRightHit) {
      xDirection *= -1;
    }
  }

  void reflectFromBall(Ball ball1, Ball ball2) {
    // Calculate the direction vector between the centers of the two balls
    Vector2 collisionNormal = ball2.position - ball1.position;
    collisionNormal.normalize();

    // Calculate the direction vectors for both balls
    Vector2 direction1 = Vector2(ball1.xDirection, ball1.yDirection);
    Vector2 direction2 = Vector2(ball2.xDirection, ball2.yDirection);

    // Calculate the relative velocity along the collision normal
    double speedAlongNormal =
        direction2.dot(collisionNormal) - direction1.dot(collisionNormal);

    if (speedAlongNormal > 0) {}

    // Calculate impulse magnitude
    double impulseMagnitude = -2 * speedAlongNormal;

    // Apply impulse to both balls
    Vector2 impulse = collisionNormal * (impulseMagnitude);

    direction1 += impulse;
    direction2 -= impulse;

    // Update directions of both balls
    ball1.xDirection = direction1.x;
    ball1.yDirection = direction1.y;
    ball2.xDirection = direction2.x;
    ball2.yDirection = direction2.y;
  }

  void reflectFromBrick(
      Set<Vector2> intersectionPoints, PositionComponent positionComponent) {
    if (intersectionPoints.length == 1) {
      sideReflection(intersectionPoints.first, positionComponent);
    } else {
      final intersectionPointsList = intersectionPoints.toList();
      final averageX =
          (intersectionPointsList[0].x + intersectionPointsList[1].x) / 2;
      final averageY =
          (intersectionPointsList[0].y + intersectionPointsList[1].y) / 2;
      if (intersectionPointsList[0].x == intersectionPointsList[1].x ||
          intersectionPointsList[0].y == intersectionPointsList[1].y) {
        sideReflection(Vector2(averageX, averageY), positionComponent);
      } else {
        cornerReflection(positionComponent, averageX, averageY);
      }
    }
  }

  void sideReflection(
      Vector2 intersectionPoints, PositionComponent positionComponent) {
    final isTopHit = intersectionPoints.y == positionComponent.position.y;
    final isBottomHit = intersectionPoints.y ==
        positionComponent.position.y + positionComponent.size.y;
    final isLeftHit = intersectionPoints.x == positionComponent.position.x;
    final isRightHit = intersectionPoints.x ==
        positionComponent.position.x + positionComponent.size.x;

    if (isTopHit || isBottomHit) {
      //
      yDirection *= -1;
    } else if (isLeftHit || isRightHit) {
      xDirection *= -1;
    }
  }

  void cornerReflection(
    PositionComponent positionComponent,
    double averageX,
    double averageY,
  ) {
    final margin = size.x / 2;
    final xPosition = positionComponent.position.x;
    final yPosition = positionComponent.position.y;
    final leftHalf =
        xPosition - margin <= averageX && averageX < xPosition + margin;
    final topHalf =
        yPosition - margin <= averageY && averageY < yPosition + margin;

    xDirection = leftHalf ? -1 : 1;
    yDirection = topHalf ? -1 : 1;
  }

  void moveBall(double dt) {
    position
      ..x += xDirection * nextPosition.x * speed
      ..y += yDirection * nextPosition.y * speed;
  }

  void moveGiftedBall(double dt) {
   
    position
      ..x += xDirection * giftedBallNextPosition.x * speed
      ..y += yDirection * giftedBallNextPosition.y * speed;
  }

  void increaseSpeed() {
    if (speed < 4) {
      speed++;
    }
  }

  void resetBall() {
    position = Vector2(
      gameRef.board.size.x / 2,
      (gameRef.board.size.y - 2 * radius) - 2,
    );
    speed = 2;
    ballState = BallState.ideal;
    aimTriangleMidPoint = Vector2(size.x / 2, -2 * size.y);
    aimTriangleBasePoint = Vector2(size.x / 4, -radius / 2);
    aimPointerBalls = List<Rect>.generate(
      16,
      (index) => Rect.fromCircle(
        center: Offset(
            aimTriangleMidPoint.x, aimTriangleMidPoint.y - (index + 1) * 20),
        radius: 3,
      ),
    );
  }

  void drawRotatedObject({
    required Canvas canvas,
    required Offset center,
    required double angle,
    required VoidCallback drawFunction,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);
    drawFunction();
    canvas.restore();
  }

  Path get aimPath {
    final path = Path()
      ..moveTo(aimTriangleMidPoint.x, aimTriangleMidPoint.y)
      ..lineTo(aimTriangleBasePoint.x, aimTriangleBasePoint.y)
      ..lineTo(3 * aimTriangleBasePoint.x, aimTriangleBasePoint.y);

    for (final ball in aimPointerBalls) {
      path.addOval(ball);
    }

    return path..close();
  }

  double get getSpawnAngle {
    final sideToThrow = Random().nextBool();
    final random = Random().nextDouble();
    final spawnAngle = sideToThrow
        ? lerpDouble(-35, 35, random)!
        : lerpDouble(145, 215, random)!;

    return spawnAngle;
  }
}
