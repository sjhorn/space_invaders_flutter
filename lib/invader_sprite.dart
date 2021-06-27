import 'dart:ui';

import 'scoring_sprite.dart';
import 'sound.dart';

class InvaderSprite extends ScoringSprite {
  final Sound invaderhit = new Sound("invaderhit.mp3");

  InvaderSprite(int row, Rect bounds, Rect location)
      : super.fromFrames([
          Rect.fromLTWH(row * 64, 0, 32, 20),
          Rect.fromLTWH(row * 64 + 32, 0, 32, 20), // Left / Right
          Rect.fromLTWH(0, 20, 32, 20),
          Rect.fromLTWH(32, 20, 32, 20), // Explosions sequence
          Rect.fromLTWH(64, 20, 32, 20),
          Rect.fromLTWH(96, 20, 32, 20)
        ], bounds, location, 5, 0) {
    score = 30 - row * 5;
  }

  @override
  void nextState() {
    frameIndex++;
    if (frameIndex > 1 && !exploding) {
      frameIndex = 0;
    }
  }

  @override
  void explode() {
    frameIndex = 2;
    invaderhit.play();
    super.explode();
  }
}
