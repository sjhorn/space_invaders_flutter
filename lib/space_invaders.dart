import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'player1_score_sprite.dart';
import 'player2_score_sprite.dart';
import 'earth_sprite.dart';
import 'shield_sprite.dart';
import 'ship1_sprite.dart';
import 'ship2_sprite.dart';
import 'invader_group.dart';

class SpaceInvaders {
  static final double GAME_WIDTH = 576;
  static final double GAME_HEIGHT = 440;
  static final logicalBounds = Rect.fromLTWH(0, 10, GAME_WIDTH, GAME_HEIGHT);

  int iteration = 0;
  int level = 0;
  bool twoPlayer = true;
  bool paused = false;

  late ui.Image _sheet;
  late PlayerOneScoreSprite playerOneScoreSprite;
  late PlayerTwoScoreSprite playerTwoScoreSprite;
  late EarthSprite earthSprite;
  late Ship1Sprite ship1Sprite;
  late Ship2Sprite ship2Sprite;

  late ShieldSprite shieldSprite1;
  late ShieldSprite shieldSprite2;
  late ShieldSprite shieldSprite3;
  late InvaderGroup invaderGroup;

  SpaceInvaders(ui.Image sheet) {
    _sheet = sheet;

    startLevel();
  }

  void startLevel() {
    if (level == 0) {
      playerOneScoreSprite = PlayerOneScoreSprite(logicalBounds);
      playerTwoScoreSprite = PlayerTwoScoreSprite(logicalBounds);
      earthSprite = EarthSprite(logicalBounds);
      ship1Sprite = Ship1Sprite(logicalBounds);
      if (twoPlayer) ship2Sprite = Ship2Sprite(logicalBounds);
    }

    double baseY = logicalBounds.height / 2 + 110;
    shieldSprite1 = ShieldSprite(logicalBounds,
        Rect.fromLTWH(logicalBounds.width / 2 - 130, baseY, 31, 36));
    shieldSprite2 = ShieldSprite(logicalBounds,
        Rect.fromLTWH(logicalBounds.width / 2 - 15, baseY, 31, 36));
    shieldSprite3 = ShieldSprite(logicalBounds,
        Rect.fromLTWH(logicalBounds.width / 2 + 100, baseY, 31, 36));

    double vaderOffset = (level % 6) * 22;
    Rect invaderBounds = Rect.fromLTWH(logicalBounds.width / 2 - 210,
        logicalBounds.height / 2 - 160 + vaderOffset, 420, 396 - vaderOffset);
    double vaderSpeed = 700000000 - (level % 6) * 25000000;
    invaderGroup = InvaderGroup(invaderBounds, vaderSpeed);
  }

  void updateModel(double timePassed) {
    if (paused) return;
    bool freeze = isFrozen();
    ship1Sprite.move(timePassed, freeze);
    if (twoPlayer) ship2Sprite.move(timePassed, freeze);
    invaderGroup.move(timePassed, freeze);

    if (invaderGroup.location.bottom > shieldSprite1.location.top) {
      shieldSprite1.hide();
      shieldSprite2.hide();
      shieldSprite3.hide();
    }
  }

  void render(Canvas canvas, Size size) {
    playerOneScoreSprite.draw(_sheet, canvas, size);
    playerTwoScoreSprite.draw(_sheet, canvas, size);
    earthSprite.draw(_sheet, canvas, size);
    ship1Sprite.draw(_sheet, canvas, size);
    ship2Sprite.draw(_sheet, canvas, size);
    shieldSprite1.draw(_sheet, canvas, size);
    shieldSprite2.draw(_sheet, canvas, size);
    shieldSprite3.draw(_sheet, canvas, size);
    invaderGroup.draw(_sheet, canvas, size);
  }

  bool isFrozen() {
    return (ship1Sprite.isStarting() || ship1Sprite.isExploding()) ||
        (twoPlayer && (ship2Sprite.isStarting() || ship2Sprite.isExploding()));
  }

  void onKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey.keyLabel) {
        case 'A':
          ship1Sprite.moveLeft = true;
          break;
        case 'D':
          ship1Sprite.moveRight = true;
          break;
        case 'J':
          ship2Sprite.moveLeft = true;
          break;
        case 'L':
          ship2Sprite.moveRight = true;
          break;
        default:
      }
    } else if (event is RawKeyUpEvent) {
      switch (event.logicalKey.keyLabel) {
        case 'A':
          ship1Sprite.moveLeft = false;
          break;
        case 'D':
          ship1Sprite.moveRight = false;
          break;
        case 'J':
          ship2Sprite.moveLeft = false;
          break;
        case 'L':
          ship2Sprite.moveRight = false;
          break;
        case 'P':
          paused = !paused;
          break;
        default:
      }
    }
  }
}
