import 'package:audioplayers/audioplayers.dart';

class Sound {
  static final Map<String, AudioCache> playersMap = {};

  late String _sound;

  Sound(this._sound) {
    if (!playersMap.containsKey(_sound)) {
      playersMap[_sound] = AudioCache(prefix: "assets/sounds/");
    }
  }

  void play() {
    AudioCache player = playersMap[_sound]!;
    player.play(_sound);
  }
}
