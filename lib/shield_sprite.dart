import 'package:flutter/material.dart';
import 'sprite.dart';

class ShieldSprite extends Sprite {
  ShieldSprite(Rect bounds, Rect location)
      : super.fromFrame(Rect.fromLTWH(185, 118, 31, 36), bounds, location);
}
