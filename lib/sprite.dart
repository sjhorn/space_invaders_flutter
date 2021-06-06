import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';

class Sprite {
  List<Rect> _spriteFrames = [];

  int frameIndex = 0;
  Rect location = Rect.fromLTWH(0, 0, 0, 0);
  Rect bounds = Rect.fromLTWH(0, 0, 0, 0);
  double speedX = 0.0;
  double speedY = 0.0;
  bool exploding = false;
  bool _hidden = false;
  Sprite? hitBy;

  Sprite();

  Sprite.fromFrame(Rect spriteFrame, this.bounds, this.location,
      [this.speedX = 0, this.speedY = 0])
      : _spriteFrames = [spriteFrame];

  Sprite.fromFrames(this._spriteFrames, this.bounds, this.location,
      [this.speedX = 0, this.speedY = 0]);

  void draw(ui.Image spriteSheet, Canvas canvas, Size size) {
    if (_hidden) return;
    Rect frame = _spriteFrames[frameIndex];
    double scale =
        min(size.width / spriteSheet.width, size.height / spriteSheet.height);
    canvas.drawImageRect(
        spriteSheet,
        frame,
        Rect.fromLTWH(location.left * scale, location.top * scale,
            frame.width * scale, frame.height * scale),
        Paint());
  }

  bool move(double timePassed, [bool stayWithinBounds = true]) {
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
}
