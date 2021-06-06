import 'package:flutter/material.dart';
import "sprite.dart";
import 'dart:ui' as ui;

class PlayerOneScoreSprite extends Sprite {
  int score = 0;

  PlayerOneScoreSprite(Rect bounds)
      : super.fromFrames([
          Rect.fromLTWH(0, 80, 42, 20), // 0
          Rect.fromLTWH(44, 80, 42, 20),
          Rect.fromLTWH(88, 80, 42, 20),
          Rect.fromLTWH(132, 80, 42, 20),
          Rect.fromLTWH(176, 80, 42, 20),
          Rect.fromLTWH(220, 80, 42, 20), // 5
          Rect.fromLTWH(264, 80, 42, 20),
          Rect.fromLTWH(308, 80, 42, 20),
          Rect.fromLTWH(352, 80, 42, 20),
          Rect.fromLTWH(396, 80, 42, 20),
          Rect.fromLTWH(440, 80, 42, 20) // 9
        ], bounds, Rect.fromLTWH(15, bounds.top, 240, 20));

  @override
  void draw(ui.Image sheet, Canvas canvas, Size size) {
    frameIndex = 0;

    String scoreString = "$score".padLeft(4, '0');

    for (int index = 0; index < 4; index++) {
      location = Rect.fromLTWH(bounds.left + 15 + index * 55, location.top,
          location.width, location.height);
      frameIndex = int.parse(scoreString[index]);
      super.draw(sheet, canvas, size);
    }
  }
}
