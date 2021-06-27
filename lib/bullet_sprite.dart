import 'dart:ui';
import 'dart:ui' as ui;

import 'package:space_invaders_2/invader_sprite.dart';
import 'package:space_invaders_2/ship1_sprite.dart';
import 'package:space_invaders_2/space_invaders.dart';

import 'ship_sprite.dart';
import 'sound.dart';
import 'sprite.dart';

enum BulletType { SHIP1, SHIP2, INVADER }

class BulletSprite extends Sprite {
  late BulletType type;
  static List<BulletSprite> bullets = [];
  static List<BulletSprite> bulletsToRemove = [];

  static bool powerMode = false;

  BulletSprite(Rect bounds, Rect location, BulletType type)
      : super.fromFrame(Rect.fromLTWH(96, 39, 3, 16), bounds, location) {
    this.type = type;
    this.speedY =
        (type == BulletType.SHIP1 || type == BulletType.SHIP2) ? -300 : 200;
  }

  static void fireFromInvader(Sprite invader) {
    Rect invaderLoc = invader.location;
    Rect location = Rect.fromLTWH(
        invaderLoc.left + invaderLoc.width / 2 - 2, invaderLoc.bottom, 3, 16);

    Rect bounds = Rect.fromLTWH(invader.bounds.left, invader.bounds.top - 16,
        invader.bounds.width, invader.bounds.height - 30);

    bullets.add(BulletSprite(bounds, location, BulletType.INVADER));
  }

  static void fireFromShip(ShipSprite ship) {
    if (ship.lives < 1) return;
    BulletType type =
        (ship is Ship1Sprite ? BulletType.SHIP1 : BulletType.SHIP2);

    // Only create a new bullet if last is gone or powerMode is on

    if (!ship.isExploding() &&
        !ship.isStarting() &&
        (powerMode || !bullets.any((e) => e.type == type))) {
      Rect shipLoc = ship.location;
      Rect location = Rect.fromLTWH(
          shipLoc.left + shipLoc.width / 2 - 2, shipLoc.top - 16, 3, 16);
      Rect bounds = Rect.fromLTWH(
          ship.bounds.left, -16, ship.bounds.width, SpaceInvaders.GAME_HEIGHT);

      bullets.add(BulletSprite(bounds, location, type));
      type == BulletType.SHIP1
          ? Sound("shipfire.mp3").play()
          : Sound("shipfire2.mp3").play();
    }
  }

  static bool moveAll(double timePassed, bool freeze) {
    if (freeze) return false;
    bool redraw = false;
    for (BulletSprite bullet in bullets) {
      if (bullet.move(timePassed)) {
        redraw = true;
      }
    }
    for (BulletSprite bullet in bulletsToRemove) {
      bullets.remove(bullet);
    }
    bulletsToRemove.clear();
    return redraw;
  }

  static void drawAll(ui.Image spriteSheet, Canvas canvas, Size size) {
    for (BulletSprite bullet in bullets) {
      bullet.draw(spriteSheet, canvas, size);
    }
  }

  static List<Sprite> detectCollisions(List sprites) {
    List<Sprite> collisions = [];
    for (Sprite sprite in sprites) {
      for (BulletSprite bullet in bullets) {
        if (sprite is InvaderSprite && bullet.type == BulletType.INVADER)
          continue;
        if (!sprite.isHidden() &&
            !sprite.isExploding() &&
            sprite.collidesWith(bullet)) {
          sprite.hitBy = bullet;
          collisions.add(sprite);
          collisions.add(bullet);
        }
      }
    }
    return collisions;
  }

  @override
  void nextState() {}

  @override
  bool move(double timePassed, [bool freeze = false]) {
    bool result = super.move(timePassed, freeze);

    if (location.top <= bounds.top || location.bottom >= bounds.bottom) {
      bulletsToRemove.add(this);
    }
    return result;
  }

  @override
  void explode() {
    if (powerMode && (type == BulletType.SHIP1 || type == BulletType.SHIP2)) {
    } else {
      BulletSprite.bullets.remove(this);
    }
  }
}
