import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'player1_score_sprite.dart';
import 'player2_score_sprite.dart';
import 'earth_sprite.dart';
import 'shield_sprite.dart';
import 'ship1_sprite.dart';
import 'ship2_sprite.dart';

class SpaceInvaders {
  int iteration = 0;
  late ui.Image _sheet;
  late PlayerOneScoreSprite playerOneScoreSprite;
  late PlayerTwoScoreSprite playerTwoScoreSprite;
  late EarthSprite earthSprite;
  late Ship1Sprite ship1Sprite;
  late Ship2Sprite ship2Sprite;

  late ShieldSprite shieldSprite1;
  late ShieldSprite shieldSprite2;
  late ShieldSprite shieldSprite3;

  SpaceInvaders(ui.Image sheet) {
    _sheet = sheet;

    Rect logicalBounds =
        Rect.fromLTWH(0, 0, sheet.width.toDouble(), sheet.height.toDouble());
    playerOneScoreSprite = PlayerOneScoreSprite(logicalBounds);
    playerTwoScoreSprite = PlayerTwoScoreSprite(logicalBounds);
    earthSprite = EarthSprite(logicalBounds);
    ship1Sprite = Ship1Sprite(logicalBounds);
    ship2Sprite = Ship2Sprite(logicalBounds);

    double baseY = logicalBounds.height / 2 + 110;
    shieldSprite1 = ShieldSprite(logicalBounds,
        Rect.fromLTWH(logicalBounds.width / 2 - 130, baseY, 31, 36));
    shieldSprite2 = ShieldSprite(logicalBounds,
        Rect.fromLTWH(logicalBounds.width / 2 - 15, baseY, 31, 36));
    shieldSprite3 = ShieldSprite(logicalBounds,
        Rect.fromLTWH(logicalBounds.width / 2 + 100, baseY, 31, 36));
  }

  void updateModel(double timePassed) {
    bool freeze = isFrozen();
    ship1Sprite.move(timePassed, freeze);
    ship2Sprite.move(timePassed, freeze);
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
  }

  bool isFrozen() {
    return false;
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
        default:
      }
    }
  }
}
