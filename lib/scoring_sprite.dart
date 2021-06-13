import 'dart:ui';

import 'sprite.dart';

class ScoringSprite extends Sprite {
  int score = 0;

  ScoringSprite.fromFrames(List<Rect> spriteFrames, Rect bounds, Rect location,
      [double speedX = 0, double speedY = 0])
      : super.fromFrames(spriteFrames, bounds, location, speedX = 0, speedY);
}
