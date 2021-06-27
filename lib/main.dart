import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'space_invaders.dart';

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';

Future<ui.Image> loadUiImage(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final list = Uint8List.view(data.buffer);
  final completer = Completer<ui.Image>();
  ui.decodeImageFromList(list, completer.complete);
  return await completer.future;
}

late ui.Image sheet;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle(SpaceInvaders.TITLE);
    setWindowMinSize(Size(SpaceInvaders.GAME_WIDTH, SpaceInvaders.GAME_HEIGHT));
    setWindowFrame(Rect.fromLTWH(
        0, 0, SpaceInvaders.GAME_WIDTH * 2, SpaceInvaders.GAME_HEIGHT * 2));
  }
  sheet = await loadUiImage("assets/images/SpriteSheet.png");

  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late SpaceInvaders _spaceInvaders = SpaceInvaders(sheet);
  late double _prevTime;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _prevTime = DateTime.now().microsecondsSinceEpoch * 1000;
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode _focusNode = FocusNode();
    FocusScope.of(context).requestFocus(_focusNode);
    return MaterialApp(
        title: SpaceInvaders.TITLE,
        theme: new ThemeData(scaffoldBackgroundColor: Colors.black),
        home: SafeArea(
            child: Scaffold(
                body: RawKeyboardListener(
                    focusNode: _focusNode,
                    onKey: _spaceInvaders.onKey,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTapDown: _spaceInvaders.onTapDown,
                        onTapUp: _spaceInvaders.onTapUp,
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            double currentTime =
                                DateTime.now().microsecondsSinceEpoch * 1000;
                            double timePassed = currentTime - _prevTime;
                            _prevTime = currentTime;

                            return CustomPaint(
                              child: Container(),
                              painter: GamePainter(_spaceInvaders, timePassed),
                            );
                          },
                        ))))));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class GamePainter extends CustomPainter {
  SpaceInvaders _spaceInvaders;
  double _timePassed;

  GamePainter(this._spaceInvaders, this._timePassed);

  @override
  void paint(Canvas canvas, Size size) {
    _spaceInvaders.updateModel(_timePassed);
    _spaceInvaders.render(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
