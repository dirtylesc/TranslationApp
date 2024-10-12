import 'package:flutter_tts/flutter_tts.dart';

class TTSExample {
  final String text;
  final String language;

  const TTSExample({
    required this.text,
    required this.language,
  });

  Future speak() async {
    final FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage(language);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }
}
