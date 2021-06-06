import 'package:space_invaders_2/ship_sprite.dart';

import 'ship_sprite.dart';

import 'package:flutter/material.dart';

class Ship1Sprite extends ShipSprite {
  Ship1Sprite(Rect bounds)
      : super.fromFrames(
            [
              Rect.fromLTWH(192, 60, 25, 20), // Blank
              Rect.fromLTWH(3, 60, 25, 20), // Normal
              Rect.fromLTWH(34, 60, 25, 20),
              Rect.fromLTWH(66, 60, 25, 20) // Explosion
            ],
            Rect.fromLTWH(bounds.width / 2 - 312 / 2,
                bounds.height / 2 + 440 / 2 - 50, 312, 20),
            Rect.fromLTWH(bounds.width / 2 - 312 / 2,
                bounds.height / 2 + 440 / 2 - 50, 25, 20)) {
    lifeRectangles = [
      Rect.fromLTWH(133, 120, 42, 20),
      Rect.fromLTWH(88, 120, 42, 20),
      Rect.fromLTWH(43, 120, 42, 20),
      Rect.fromLTWH(0, 120, 42, 20)
    ];
    livesOffset = -62;
  }

  @override
  void positionShip() {
    location =
        Rect.fromLTWH(bounds.left, bounds.top, location.width, location.height);
  }
}
