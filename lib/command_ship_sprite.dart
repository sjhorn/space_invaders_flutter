import 'dart:math';
import 'dart:ui';

import 'scoring_sprite.dart';
import 'sound.dart';

class CommandShipSprite extends ScoringSprite {
  static const double EXPLODING_TIME = 1200000000;
  static final Sound commandshiphit = Sound("commandshiphit.mp3");
  static final Sound commandshipmove = Sound("commandship.mp3");

  double soundTime = 0;
  double explosionFrameTime = 0;

  CommandShipSprite(Rect bounds)
      : super.fromFrames(
            [
              Rect.fromLTWH(0, 40, 30, 20),
              Rect.fromLTWH(30, 40, 30, 20),
              Rect.fromLTWH(60, 40, 30, 20), // Explosions sequence
              Rect.fromLTWH(30, 40, 30, 20), Rect.fromLTWH(60, 40, 30, 20)
            ],
            Rect.fromLTWH(
                bounds.left - 20, bounds.top, bounds.width + 40, bounds.height),
            Rect.fromLTWH(bounds.left, bounds.top, 30, 20)) {
    score = 200;
    stayWithinBounds = false;
    speedX = 0;
    hide();
  }

  @override
  bool move(double timePassed, [bool freeze = false]) {
    if (isHidden() || freeze) {
      return false;
    }
    if (exploding) {
      speedX = 0;
      explosionFrameTime += timePassed;
      if (explosionFrameTime > EXPLODING_TIME) {
        nextState();
        explosionFrameTime = 0;
        hide();
      }
    } else if (location.left <= bounds.right && location.right >= bounds.left) {
      soundTime += timePassed;
      if (soundTime > 360000000) {
        commandshipmove.play();
        soundTime = 0;
      }
      return super.move(timePassed, false);
    } else {
      hide();
    }
    return false;
  }

  void nextState() {
    if (frameIndex >= spriteFrames.length) {
      hide();
      frameIndex = 0;
    } else if (exploding) {
      frameIndex++;
    } else {
      frameIndex = 0;
    }
  }

  void explode() {
    commandshipmove.stop();
    frameIndex = 1;
    exploding = true;
    commandshiphit.play();
  }

  @override
  void show() {
    exploding = false;
    bool right = Random().nextInt(2) == 1;
    location = Rect.fromLTWH(
        right ? bounds.left - 20 : bounds.right, bounds.top, 30, 20);
    speedX = right ? 70 : -70;
    frameIndex = 0;
    super.show();
  }
}
