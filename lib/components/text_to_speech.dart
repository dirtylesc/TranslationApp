import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

class TTS {
  static final FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;
  String prevLanguage = 'en-US';

  TTS() {
    _initHandlers();
  }

  bool get isPlaying => ttsState == TtsState.playing;

  bool get isStopped => ttsState == TtsState.stopped;

  void _initHandlers() {
    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
    });

    flutterTts.setErrorHandler((dynamic msg) {
      ttsState = TtsState.stopped;
    });
  }

  Future speak(String text, String language) async {
    prevLanguage = language;

    await flutterTts.setLanguage(language);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  Future stop() async {
    dynamic result = await flutterTts.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }
}
