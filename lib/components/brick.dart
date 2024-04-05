import 'dart:async';
import 'dart:math';

import 'package:brick_breaker/bloc/inventory_bloc/inventory_bloc.dart';
import 'package:brick_breaker/bloc/inventory_bloc/inventory_bloc_events.dart';
import 'package:brick_breaker/bricks_breaker.dart';
import 'package:brick_breaker/components/ball.dart';
import 'package:brick_breaker/game_manager/game_manager.dart';
import 'package:brick_breaker/utils/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class Brick extends PositionComponent
    with CollisionCallbacks, HasGameRef<BricksBreaker> {
  Brick({
    required this.brickValue,
    required this.brickRow,
    required this.brickColumn,
    required double size,
  }) : super(
          size: Vector2.all(size),
        );

  int brickValue;
  int brickRow;
  int brickColumn;
  bool hasCollided = false;
  late final TextComponent brickText;
  late final RectangleHitbox rectangleBrickHitBox;
  late final RectangleComponent rectangleBrick;
  static GameManager gameManager = GameManager();
  RemovedSprite? removedSprite;
  late InventoryBloc inventoryBloc;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    inventoryBloc = InventoryBloc();
    if (brickValue <= 0) {
      removeFromParent();
    }

    brickText = createBrickTextComponent();
    rectangleBrick = createBrickRectangleComponent();
    rectangleBrickHitBox = createBrickRectangleHitbox();

    addAll([
      rectangleBrick,
      rectangleBrickHitBox,
      brickText,
    ]);
  }

  @override
  void update(double dt) {
    if (hasCollided && brickText.text != gift && brickText.text != ballGift) {
      brickText.text = '$brickValue';
      inventoryBloc.add(AddBrickEvent());
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ball && !hasCollided) {
      handleCollision();
      hasCollided = true;
    }
    super.onCollision(intersectionPoints, other);
  }

  bool generateWithProbability(double percent) {
    final Random rand = Random();

    var randomInt = rand.nextInt(100) + 1;

    if (randomInt <= percent) {
      return true;
    }

    return false;
  }

  TextComponent createBrickTextComponent() {
    return TextComponent(
      text: generateBrickText(),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(brickFontColor),
          fontSize: brickFontSize, //30,
        ),
      ),
    )..center = size / 2;
  }

  String generateBrickText() {
    if (generateWithProbability(powerUpProbability)) {
      return brickRowRemoverText;
    } else if (generateWithProbability(powerUpProbability)) {
      return brickColumnRemoverText;
    } else if (generateWithProbability(powerUpAppleProbability)) {
      return gift;
    } else if (generateWithProbability(powerUpBallProbability)) {
      return ballGift;
    } else {
      return '$brickValue';
    }
  }

  RectangleHitbox createBrickRectangleHitbox() {
    return RectangleHitbox(
      size: size,
    );
  }

  RectangleComponent createBrickRectangleComponent() {
    return RectangleComponent(
      size: size,
      paint: Paint()
        ..style = PaintingStyle.fill
        ..color = const Color(brickColor),
    );
  }

  Future<void> handleCollision() async {
    if (hasCollided) return;

    hasCollided = true;
    final spr = await gameRef.loadSprite("explosion.png");
    if (brickText.text == brickRowRemoverText) {
      gameRef.removeBrickLayerRow(brickRow);
      FlameAudio.play(brickRowRemoverAudio);
      showNDisposeSprite(spr);
      inventoryBloc.add(AddGerenadeEvent());
    }
    if (brickText.text == brickColumnRemoverText) {
      gameRef.removeBrickLayerColumn(brickColumn);
      FlameAudio.play(brickColumnRemoverAudio);
      showNDisposeSprite(spr);
      inventoryBloc.add(AddBombEvent());

      //
    }
    if (brickText.text == gift) {
      FlameAudio.play(ballAudio);

      // await makeGiftFall();

      gameRef.addGiftScores();
      removeFromParent();
      showNDisposeSprite(spr);
      inventoryBloc.add(AddGiftEvent());
      //
    }
    if (brickText.text == ballGift) {
      FlameAudio.play(ballAudio);

      // await makeGiftFall();
      gameRef.addGiftBall();
      removeFromParent();
      showNDisposeSprite(spr);
      inventoryBloc.add(AddBallEvent());
      //
    }

    FlameAudio.play(ballAudio);
    if (--brickValue == 0) {
      removeFromParent();
      inventoryBloc.add(AddBrickEvent());

      //
    }
  }

  showNDisposeSprite(Sprite spr) async {
    removedSprite = RemovedSprite(sprite: spr, position: position);
    gameRef.add(removedSprite!);
    await Future.delayed(const Duration(milliseconds: 200));
    gameRef.remove(removedSprite!);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (hasCollided) {
      hasCollided = false;
    }
    super.onCollisionEnd(other);
  }

  // makeGiftFall() async {
  //   while (position.y < gameRef.size.y) {
  //     position.y += 10;
  //     await Future.delayed(const Duration(milliseconds: 50));
  //   }
  // }
}

class RemovedSprite extends SpriteComponent {
  RemovedSprite({
    required Sprite sprite,
    required Vector2 position,
  }) : super(sprite: sprite, position: position);
}
