import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;

import 'invader_sprite.dart';
import 'sound.dart';
import 'sprite.dart';

class InvaderGroup extends Sprite {
  late double waitTime;
  late Rect location;
  late Rect bounds;
  double moveTime = 0;
  double explosionTime = 0;
  double fireTime = 0;
  int dir = 1;
  int dx = 5;
  int dy = 0;
  int delta = 5;

  Random r = Random();
  List<InvaderSprite> invaders = [];
  List<InvaderSprite> invadersToRemove = [];
  Map<int, List<InvaderSprite>> invaderColumn = {};
  Sound _invaderSound = Sound("invaders.wav");

  InvaderGroup(Rect bounds, [double waitTime = 700000000]) {
    this.bounds = bounds;
    this.waitTime = waitTime;

    for (int row = 0; row <= 5; row++) {
      for (int col = 0; col <= 5; col++) {
        InvaderSprite sprite = InvaderSprite(
            row,
            bounds,
            Rect.fromLTWH(
                bounds.left + col * 58, bounds.top + row * 35, 32, 20));
        invaders.add(sprite);
        if (row == 0) invaderColumn[col] = [];
        invaderColumn[col]!.add(sprite);
      }
    }
    Rect firstInvader = invaders[0].location;
    Rect lastInvader = invaders.last.location;
    location = Rect.fromLTWH(
        firstInvader.left,
        firstInvader.top,
        lastInvader.right - firstInvader.left,
        lastInvader.bottom - firstInvader.top);
  }

  @override
  bool move(double timePassed, [bool freeze = false]) {
    explosionTime += timePassed;

    if (explosionTime > 120000000) {
      for (var sprite in invaders) {
        if (sprite.exploding) {
          sprite.nextState();

          if (sprite.frameIndex >= sprite.spriteFrames.length) {
            waitTime -= 15000000;
            invadersToRemove.add(sprite);
            for (MapEntry<int, List<InvaderSprite>> entry
                in invaderColumn.entries) {
              entry.value.remove(sprite);
            }
          }
        }
      }

      for (var sprite in invadersToRemove) invaders.remove(sprite);
      invadersToRemove.clear();
      if (invaders.length == 0) {
        //invaderSound.stop();
      }
      explosionTime = 0;
    }
    if (!freeze && invaders.length > 0) {
      moveTime += timePassed;
      fireTime += timePassed;

      if (fireTime > 800000000) {
        // int col = r.nextInt(6);
        // if (invaderColumn[col]!.length > 0) {
        //   Sprite invader = invaderColumn[col]!.last;
        //   BulletSprite.fireFromInvader(invader);
        // }
        fireTime = 0;
      }

      if (moveTime >
              waitTime /*&&
          invaders.fold(false, (prev, it) => !it.isExploding())*/
          ) {
        _invaderSound.play();
        int vaderLength = invaders.length;
        if (vaderLength <= 36 && vaderLength >= 25) {
          delta = 5;
        } else if (vaderLength <= 24 && vaderLength >= 17) {
          delta = 7;
        } else if (vaderLength <= 16 && vaderLength >= 13) {
          delta = 10;
        } else if (vaderLength <= 12 && vaderLength >= 6) {
          delta = 12;
        } else {
          delta = 15;
        }

        dy = 0;
        if (location.right >= bounds.right) {
          dy = 22;
          dir = -1;
        } else if (location.left < bounds.left) {
          dy = 22;
          dir = 1;
        }
        dx = delta * dir;
        double left = double.infinity,
            top = double.infinity,
            right = 0,
            bottom = 0;
        for (var sprite in invaders) {
          Rect loc = sprite.location;

          // Adjust the sprite
          sprite.location =
              Rect.fromLTWH(loc.left + dx, loc.top + dy, loc.width, loc.height);

          loc = sprite.location;

          // Adjust the formations bounds
          left = loc.left < left ? loc.left : left;
          top = loc.top < top ? loc.top : top;
          right = loc.right > right ? loc.right : right;
          bottom = loc.bottom > bottom ? loc.bottom : bottom;

          if (!sprite.exploding) {
            sprite.nextState();
          }
        }
        location = Rect.fromLTWH(left, top, right - left, bottom - top);
        moveTime = 0;
      }
    }
    return true;
  }

  @override
  void draw(ui.Image spriteSheet, Canvas canvas, Size size) {
    for (var sprite in invaders) {
      sprite.draw(spriteSheet, canvas, size);
    }
  }
}
