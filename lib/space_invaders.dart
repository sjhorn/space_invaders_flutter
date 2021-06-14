import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_invaders_2/scoring_sprite.dart';
import 'package:space_invaders_2/ship_sprite.dart';
import 'dart:ui' as ui;

import 'bullet_sprite.dart';
import 'player1_score_sprite.dart';
import 'player2_score_sprite.dart';
import 'earth_sprite.dart';
import 'shield_sprite.dart';
import 'ship1_sprite.dart';
import 'ship2_sprite.dart';
import 'invader_group.dart';

import 'package:window_size/window_size.dart';
import 'dart:io' show Platform;

import 'sprite.dart';

class SpaceInvaders {
  static const String TITLE = "Flutter Space Invaders";
  static const double GAME_WIDTH = 576;
  static const double GAME_HEIGHT = 440;
  static const logicalBounds = Rect.fromLTWH(0, 10, GAME_WIDTH, GAME_HEIGHT);

  int iteration = 0;
  int level = 0;
  bool twoPlayer = false;
  bool paused = false;
  bool gameOver = false;
  double gameOverTime = 0;
  double commandShipTime = 0;

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

  static setTitle(String title) {
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      setWindowTitle(title);
    }
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(label: title));
  }

  SpaceInvaders(ui.Image sheet) {
    _sheet = sheet;

    startLevel();
  }

  void startLevel() {
    setTitle(
        "$TITLE - Level $level - ${twoPlayer ? 'Two Player' : 'One Player'}");

    // Add Players
    if (level == 0) {
      playerOneScoreSprite = PlayerOneScoreSprite(logicalBounds);
      playerTwoScoreSprite = PlayerTwoScoreSprite(logicalBounds);
      earthSprite = EarthSprite(logicalBounds);
      ship1Sprite = Ship1Sprite(logicalBounds);
      ship2Sprite = Ship2Sprite(logicalBounds);
    }

    // Add bases
    double baseY = logicalBounds.height / 2 + 110;
    shieldSprite1 = ShieldSprite(logicalBounds,
        Rect.fromLTWH(logicalBounds.width / 2 - 130, baseY, 31, 36));
    shieldSprite2 = ShieldSprite(logicalBounds,
        Rect.fromLTWH(logicalBounds.width / 2 - 15, baseY, 31, 36));
    shieldSprite3 = ShieldSprite(logicalBounds,
        Rect.fromLTWH(logicalBounds.width / 2 + 100, baseY, 31, 36));

    // Add space invaders
    double vaderOffset = (level % 6) * 22;
    Rect invaderBounds = Rect.fromLTWH(logicalBounds.width / 2 - 210,
        logicalBounds.height / 2 - 160 + vaderOffset, 420, 396 - vaderOffset);
    double vaderSpeed = 700000000 - (level % 6) * 25000000;
    invaderGroup = InvaderGroup(invaderBounds, vaderSpeed);

    BulletSprite.bullets.clear();
  }

  void newLevel() {
    level++;
    startLevel();
    if (ship1Sprite.lives > 0) {
      ship1Sprite.newLevel();
    }
    if (twoPlayer && ship2Sprite.lives > 0) {
      ship2Sprite.newLevel();
    }
  }

  void updateModel(double timePassed) {
    if (paused) return;

    if (gameOver) {
      gameOverTime += timePassed;
      if (gameOverTime > 3000000000) {
        gameOver = false;
        gameOverTime = 0;
        startLevel();
      }
    } else {
      bool freeze = isFrozen();
      ship1Sprite.move(timePassed, freeze);
      if (twoPlayer) ship2Sprite.move(timePassed, freeze);
      invaderGroup.move(timePassed, freeze);

      if (freeze) {
      } else if (invaderGroup.invaders.length == 0) {
        newLevel();
      } else if (invaderGroup.location.bottom >= ship1Sprite.location.top) {
        doGameOver();
        ShipSprite.shiphit.play();
      } else if ((!twoPlayer && ship1Sprite.lives < 1) ||
          (ship1Sprite.lives < 1 && ship2Sprite.lives < 1)) {
        doGameOver();
      } else {
        BulletSprite.moveAll(timePassed, freeze);

        List<Sprite> sprites = [
          ...invaderGroup.invaders,
          shieldSprite1,
          shieldSprite2,
          shieldSprite3,
          if (ship1Sprite.lives > 0) ship1Sprite,
          if (ship2Sprite.lives > 0) ship2Sprite,
        ];

        for (Sprite sprite in BulletSprite.detectCollisions(sprites)) {
          sprite.explode();
          if (sprite is ScoringSprite) {
            BulletSprite bullet = sprite.hitBy as BulletSprite;
            if (bullet.type == BulletType.SHIP1) {
              playerOneScoreSprite.score += sprite.score;
            } else {
              playerTwoScoreSprite.score += sprite.score;
            }
          } else if (sprite is ShipSprite) {
            BulletSprite.bullets.clear(); // Clear bullets after ships explodes
          }
        }

        if (invaderGroup.location.bottom > shieldSprite1.location.top) {
          shieldSprite1.hide();
          shieldSprite2.hide();
          shieldSprite3.hide();
        }
      }
    }
  }

  void render(Canvas canvas, Size size) {
    playerOneScoreSprite.draw(_sheet, canvas, size);
    playerTwoScoreSprite.draw(_sheet, canvas, size);
    earthSprite.draw(_sheet, canvas, size);
    ship1Sprite.draw(_sheet, canvas, size);
    if (twoPlayer) ship2Sprite.draw(_sheet, canvas, size);
    shieldSprite1.draw(_sheet, canvas, size);
    shieldSprite2.draw(_sheet, canvas, size);
    shieldSprite3.draw(_sheet, canvas, size);
    invaderGroup.draw(_sheet, canvas, size);

    BulletSprite.drawAll(_sheet, canvas, size);
  }

  bool isFrozen() {
    return (ship1Sprite.isStarting() || ship1Sprite.isExploding()) ||
        (twoPlayer && (ship2Sprite.isStarting() || ship2Sprite.isExploding()));
  }

  void onKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey.keyLabel) {
        case 'A':
          ship1Sprite.leftOn();
          break;
        case 'S':
          if (!isFrozen()) ship1Sprite.fire();
          break;
        case 'D':
          ship1Sprite.rightOn();
          break;
        case 'J':
          ship2Sprite.leftOn();
          break;
        case 'K':
          if (!isFrozen()) ship2Sprite.fire();
          break;
        case 'L':
          ship2Sprite.rightOff();
          break;

        default:
      }
    } else if (event is RawKeyUpEvent) {
      switch (event.logicalKey.keyLabel) {
        case 'A':
          ship1Sprite.leftOff();
          break;
        case 'D':
          ship1Sprite.rightOff();
          break;
        case 'J':
          ship2Sprite.leftOff();
          break;
        case 'L':
          ship2Sprite.rightOff();
          break;
        case 'P':
          paused = !paused;
          break;
        case '1':
          twoPlayer = false;
          resetAndStart();
          break;
        case '2':
          twoPlayer = true;
          resetAndStart();
          break;
        case 'R':
          resetAndStart();
          break;
        default:
      }
    }
  }

  void resetAndStart() {
    reset();
    startLevel();
  }

  void doGameOver() {
    gameOver = true;
    reset();
  }

  void reset() {
    level = 0;
    BulletSprite.bullets.clear();
    ship1Sprite.hide();
    if (twoPlayer) ship2Sprite.hide();
  }
}
