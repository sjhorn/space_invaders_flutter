import 'package:flutter/material.dart';
import "sprite.dart";
import 'dart:ui' as ui;

class PlayerTwoScoreSprite extends Sprite {
  int score = 0;

  PlayerTwoScoreSprite(Rect bounds)
      : super.fromFrames([
          Rect.fromLTWH(0, 99, 42, 20), // 0
          Rect.fromLTWH(44, 99, 42, 20),
          Rect.fromLTWH(88, 99, 42, 20),
          Rect.fromLTWH(132, 99, 42, 20),
          Rect.fromLTWH(176, 99, 42, 20),
          Rect.fromLTWH(220, 99, 42, 20), // 5
          Rect.fromLTWH(264, 99, 42, 20),
          Rect.fromLTWH(308, 99, 42, 20),
          Rect.fromLTWH(352, 99, 42, 20),
          Rect.fromLTWH(396, 99, 42, 20),
          Rect.fromLTWH(440, 99, 42, 20) // 9
        ], bounds, Rect.fromLTWH(15, bounds.top, 240, 20));

  @override
  void draw(ui.Image sheet, Canvas canvas, Size size) {
    frameIndex = 0;
    int scoreLeft = sheet.width - 4 * 55;
    String scoreString = "$score".padLeft(4, '0');

    for (int index = 0; index < 4; index++) {
      location = Rect.fromLTWH(bounds.left + scoreLeft + index * 55,
          location.top, location.width, location.height);
      frameIndex = int.parse(scoreString[index]);
      super.draw(sheet, canvas, size);
    }
  }
}
