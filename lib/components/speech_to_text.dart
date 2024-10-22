import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class STT {
  static final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  STT() {
    _initSpeech();
  }

  Future _initSpeech() async {
    // _speechEnabled = await _speechToText.initialize();
  }

  Future startListening() async {
    // await _speechToText.listen(onResult: _onSpeechResult);
  }

  Future stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
  }
}
