import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'bullet_sprite.dart';
import 'sound.dart';
import 'space_invaders.dart';
import 'sprite.dart';

abstract class ShipSprite extends Sprite {
  static const double STARTING_TIME = 2000000000;
  static const double EXPLODING_TIME = 1200000000;

  static final Sound shiphit = Sound("shiphit.wav");
  double startingTime = STARTING_TIME;
  double explodingTime = 0;
  double blinkFrameTime = 0;
  double explosionFrameTime = 0;

  bool moveLeft = false;
  bool moveRight = false;

  List<Rect> lifeRectangles = [];
  int livesOffset = 0;
  int lives = 3;

  ShipSprite.fromFrames(List<Rect> spriteFrames, Rect bounds, Rect location)
      : super.fromFrames(spriteFrames, bounds, location);

  void positionShip();

  void nextState() {
    frameIndex++;
    if (isStarting() && frameIndex > 1) {
      frameIndex = 0;
    } else if (isExploding() && frameIndex > 3) {
      frameIndex = 2;
    }
  }

  void draw(ui.Image sheet, Canvas canvas, Size size) {
    if (isStarting()) {
      Rect l = lifeRectangles[lives];
      double scale = min(size.width / SpaceInvaders.GAME_WIDTH,
          size.height / SpaceInvaders.GAME_HEIGHT);
      canvas.drawImageRect(
          sheet,
          l,
          Rect.fromLTWH((bounds.left + bounds.width / 2 + livesOffset) * scale,
              location.top * scale, 42 * scale, 20 * scale),
          new Paint());
      super.draw(sheet, canvas, size);
    } else if (lives > 0) {
      super.draw(sheet, canvas, size);
    }
  }

  bool isStarting() {
    return startingTime > 0;
  }

  bool isExploding() {
    return explodingTime > 0;
  }

  void newLife() {
    positionShip();
    exploding = false;
    frameIndex = 0;
    startingTime = STARTING_TIME;
  }

  void newLevel() {
    positionShip();
    startingTime = STARTING_TIME;
  }

  void explode() {
    explodingTime = EXPLODING_TIME;
    frameIndex = 2;
    shiphit.play();
    super.explode();
  }

  bool move(double timePassed, [bool freeze = false]) {
    if (isStarting() || lives < 1) {
      speedX = 0;
      startingTime -= timePassed;
      blinkFrameTime += timePassed;
      if (blinkFrameTime > 250000000) {
        nextState();
        blinkFrameTime = 0;
      }
    } else if (isExploding()) {
      speedX = 0;
      explodingTime -= timePassed;
      explosionFrameTime += timePassed;
      if (blinkFrameTime > 120000000) {
        nextState();
        explosionFrameTime = 0;
      }
      if (!isExploding()) {
        newLife();
        if (lives > 0) lives--;
      }
    } else if (freeze) {
      positionShip();
      return false;
    } else {
      frameIndex = 1;
      if (moveLeft) {
        speedX = -300;
      } else if (moveRight) {
        speedX = 300;
      } else {
        speedX = 0;
        return false;
      }
    }

    return super.move(timePassed, true);
  }

  void fire() {
    BulletSprite.fireFromShip(this);
  }

  void leftOn() {
    moveLeft = true;
  }

  void leftOff() {
    moveLeft = false;
  }

  void rightOn() {
    moveRight = true;
  }

  void rightOff() {
    moveRight = false;
  }
}
