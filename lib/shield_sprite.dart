import 'dart:math';

import 'package:flutter/material.dart';
import 'space_invaders.dart';
import 'sprite.dart';
import 'dart:ui' as ui;

class ShieldSprite extends Sprite {
  static const int BOTTOM = 0x01;
  static const int MIDDLE = 0x02;
  static const int TOP = 0x04;
  static const int ALL = 0x07;

  List<Rect> damageRects = [];
  Map<int, int> damage = {};

  ShieldSprite(Rect bounds, Rect location)
      : super.fromFrame(Rect.fromLTWH(185, 118, 31, 36), bounds, location) {
    int left = location.left.toInt();
    int right = location.right.toInt();

    // Note the existing damage to the square (ie lines on each side at top of shield)
    for (int it = 0; it <= 4; it++) {
      damage[left + it] = TOP;
      damage[right - it] = TOP;
    }
  }

  @override
  void draw(ui.Image spriteSheet, Canvas canvas, Size size) {
    double scale = min(size.width / SpaceInvaders.GAME_WIDTH,
        size.height / SpaceInvaders.GAME_HEIGHT);
    if (!isHidden()) {
      super.draw(spriteSheet, canvas, size);
      Paint paint = new Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.black;

      for (Rect dr in damageRects) {
        Rect scaled = Rect.fromLTWH(
            (dr.left * scale).round().toDouble(),
            (dr.top * scale).round().toDouble(),
            (dr.width * scale).round().toDouble(),
            (dr.height * scale).round().toDouble());
        canvas.drawRect(scaled, paint);
      }
    }
  }

  @override
  void explode() {}

  @override
  bool collidesWith(Sprite sprite) {
    if (super.collidesWith(sprite)) {
      int left = sprite.location.left.toInt();
      int columnDamage = damage.containsKey(left) ? damage[left]! : 0;

      // If the shield is fully damaged let the bullet through
      if (columnDamage == ALL) {
        return false;
      }

      // Add damage depending on whether we are coming from top or bottom
      if (sprite.speedY > 0) {
        if ((columnDamage & TOP) != TOP) {
          addDamage(left, TOP);
        } else if ((columnDamage & MIDDLE) != MIDDLE) {
          addDamage(left, MIDDLE);
        } else {
          addDamage(left, BOTTOM);
        }
      } else {
        if ((columnDamage & BOTTOM) != BOTTOM) {
          addDamage(left, BOTTOM);
        } else if ((columnDamage & MIDDLE) != MIDDLE) {
          addDamage(left, MIDDLE);
        } else {
          addDamage(left, TOP);
        }
      }
      return true;
    }
    return false;
  }

  void addDamage(int left, int level) {
    int top = location.top.toInt();
    switch (level) {
      case MIDDLE:
        top += 12;
        break;
      case BOTTOM:
        top += 24;
        break;
    }

    // Vertical line damage
    damageRects.add(new Rect.fromLTWH(left.toDouble(), top.toDouble(), 4, 16));

    // Some horizontal damage added to veritical radomly
    Random random = new Random(DateTime.now().microsecond);
    switch (random.nextInt(5)) {
      case 0:
        damageRects.add(Rect.fromLTWH(left - 3, top + 9, 3, 4));
        break;
      case 1:
        damageRects.add(Rect.fromLTWH(left + 4, top + 7, 4, 4));
        break;
      case 2:
        damageRects.add(Rect.fromLTWH(left - 4, top + 1, 4, 4));
        break;
      case 3:
        damageRects.add(Rect.fromLTWH(left + 4, top + 3, 3, 4));
        break;
      default:
        // do nothing
        break;
    }

    // Or together the damage.
    if (damage.containsKey(left)) {
      damage[left] = damage[left]! | level;
    } else {
      damage[left] = level;
    }
  }
}
