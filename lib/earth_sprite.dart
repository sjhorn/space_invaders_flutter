import 'package:flutter/material.dart';
import "sprite.dart";

class EarthSprite extends Sprite {
  EarthSprite(Rect bounds)
      : super.fromFrame(
            Rect.fromLTWH(0, 160, 576, 30),
            bounds,
            Rect.fromLTWH(bounds.width / 2 - 576 / 2,
                bounds.height / 2 + 440 / 2 - 30, 576, 30));
}
