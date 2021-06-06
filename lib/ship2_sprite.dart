import 'package:flutter/material.dart';
import 'ship_sprite.dart';

class Ship2Sprite extends ShipSprite {
  Ship2Sprite(Rect bounds)
      : super.fromFrames(
            [
              Rect.fromLTWH(192, 60, 25, 20), // Blank
              Rect.fromLTWH(96, 60, 25, 20), // Normal
              Rect.fromLTWH(128, 60, 25, 20),
              Rect.fromLTWH(160, 60, 25, 20) // Explosion
            ],
            Rect.fromLTWH(bounds.width / 2 - 312 / 2,
                bounds.height / 2 + 440 / 2 - 50, 312, 20),
            Rect.fromLTWH(bounds.width / 2 + 312 / 2 - 25,
                bounds.height / 2 + 440 / 2 - 50, 25, 20)) {
    lifeRectangles = [
      Rect.fromLTWH(133, 120, 42, 20),
      Rect.fromLTWH(88, 120, 42, 20),
      Rect.fromLTWH(43, 120, 42, 20),
      Rect.fromLTWH(0, 120, 42, 20)
    ];
  }
  @override
  void positionShip() {
    location = Rect.fromLTWH(bounds.right - location.width, bounds.top,
        location.width, location.height);
  }
}
