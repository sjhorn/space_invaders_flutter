import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Sound {
  static final Map<String, CachedSound> uriMap = {};

  bool soundEnabled = kIsWeb || !Platform.isLinux;
  late String _sound;
  String prefix = "assets/sounds/";

  Sound(this._sound);

  void play() async {
    if (!soundEnabled) return;
    CachedSound cachedSound;
    if (!uriMap.containsKey(_sound)) {
      String uri = await fetchToMemory(_sound);
      if (uri.length == 0) return;
      AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
      audioPlayer.setReleaseMode(ReleaseMode.STOP);
      cachedSound = CachedSound(uri, audioPlayer);
      uriMap[_sound] = cachedSound;
    } else {
      cachedSound = uriMap[_sound]!;
    }

    cachedSound.audioPlayer
        .play(cachedSound.uri,
            volume: 1.0,
            respectSilence: true,
            stayAwake: false,
            recordingActive: false,
            duckAudio:
                true // used for playing sound while other sound may be playing
            )
        .catchError((e) {
      print("Audio error $e");
    });
  }

  Future<String> fetchToMemory(String fileName) async {
    if (kIsWeb) {
      final uri = Uri.parse("assets/$prefix$fileName");

      // We rely on browser caching here. Once the browser downloads this file,
      // the native side implementation should be able to access it from cache.

      await http.get(uri);
      return uri.toString();
    }

    // read local asset from rootBundle
    final byteData = await rootBundle.load('$prefix$fileName');

    // create a temporary file on the device to be read by the native side
    final file = File('${(await getTemporaryDirectory()).path}/$fileName');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List());

    // returns the local file uri
    return file.uri.toString();
  }
}

class CachedSound {
  String uri;
  AudioPlayer audioPlayer;

  CachedSound(this.uri, this.audioPlayer);
}
