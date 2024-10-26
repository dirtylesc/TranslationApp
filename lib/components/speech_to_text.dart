import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Stt extends StatefulWidget {
  final Function(String) onListened;
  final Function() onStopped;
  final String? sourceLanguage;
  const Stt(
      {super.key,
      this.sourceLanguage,
      required this.onListened,
      required this.onStopped});

  @override
  State<Stt> createState() => _SttState();
}

class _SttState extends State<Stt> {
  var isListening = false;
  SpeechToText speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    checkMicrophonePermission();
  }

  Future<void> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      initializeSpeechRecognizer();
    } else {
      if (kDebugMode) {
        print("Microphone permission not granted");
      }
    }
  }

  Future<void> initializeSpeechRecognizer() async {
    try {
      bool available = await speechToText.initialize();
      if (!available) {
        if (kDebugMode) {
          print("Speech recognition not available on this device.");
        }
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error initializing SpeechToText: ${e.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!isListening) {
          var available = await speechToText.initialize();
          if (available) {
            setState(() {
              isListening = true;
            });
            speechToText.listen(
                localeId: widget.sourceLanguage,
                listenFor: const Duration(days: 1),
                onResult: (result) {
                  setState(() {
                    widget.onListened.call(result.recognizedWords);
                  });
                });
          }
        } else {
          setState(() {
            isListening = false;
          });
          speechToText.stop();
          widget.onStopped.call();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color:
                isListening ? Colors.red : const Color.fromRGBO(0, 51, 102, 1),
            borderRadius: BorderRadius.circular(100)),
        child: Icon(
          color: Colors.white,
          isListening ? Icons.square : Icons.mic,
        ),
      ),
    );
  }
}
