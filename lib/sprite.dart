import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';

import 'space_invaders.dart';

class Sprite {
  List<Rect> spriteFrames = [];

  int frameIndex = 0;
  Rect location = Rect.fromLTWH(0, 0, 0, 0);
  Rect bounds = Rect.fromLTWH(0, 0, 0, 0);
  double speedX = 0.0;
  double speedY = 0.0;
  bool exploding = false;
  bool _hidden = false;
  Sprite? hitBy;
  bool stayWithinBounds = true;

  Sprite();

  Sprite.fromFrame(Rect spriteFrame, this.bounds, this.location,
      [this.speedX = 0, this.speedY = 0])
      : spriteFrames = [spriteFrame];

  Sprite.fromFrames(this.spriteFrames, this.bounds, this.location,
      [this.speedX = 0, this.speedY = 0]);

  void draw(ui.Image spriteSheet, Canvas canvas, Size size) {
    if (_hidden) return;
    Rect frame = spriteFrames[frameIndex];
    double scale = min(size.width / SpaceInvaders.GAME_WIDTH,
        size.height / SpaceInvaders.GAME_HEIGHT);
    canvas.drawImageRect(
        spriteSheet,
        frame,
        Rect.fromLTWH(
            (location.left * scale).round().toDouble(),
            (location.top * scale).round().toDouble(),
            (frame.width * scale).round().toDouble(),
            (frame.height * scale).round().toDouble()),
        Paint());
  }

  bool move(double timePassed, [bool freeze = false]) {
    double newX = location.left + timePassed * speedX / 1000000000;

    if (stayWithinBounds && newX + location.width > bounds.right) {
      newX = bounds.right - location.width;
    } else if (stayWithinBounds && newX < bounds.left) {
      newX = bounds.left;
    }

    double newY = location.top + timePassed * speedY / 1000000000;
    if (stayWithinBounds && newY + location.height > bounds.bottom) {
      newY = bounds.bottom - location.height;
    } else if (stayWithinBounds && newY < bounds.top) {
      newY = bounds.top;
    }

    location = Rect.fromLTWH(newX, newY, location.width, location.height);

    return true;
  }

  bool collidesWith(Sprite sprite) {
    return sprite.location.intersect(location).width > 0;
  }

  void nextState() {}

  void explode() {
    exploding = true;
  }

  void hide() {
    _hidden = true;
  }

  bool isExploding() {
    return exploding;
  }
}
