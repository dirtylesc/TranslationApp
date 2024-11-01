import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translation_app/pages/home.dart';
import 'package:translation_app/constants/languages.dart';
import 'package:translation_app/components/helper.dart';
import 'package:translation_app/components/language_changed_box.dart';

class TranslationOverlay extends StatefulWidget {
  const TranslationOverlay({super.key});

  @override
  State<TranslationOverlay> createState() => _TranslationOverlayState();
}

class _TranslationOverlayState extends State<TranslationOverlay> {
  static GlobalKey previewContainer = GlobalKey();
  bool _isFullScreen = false;
  String _sourceText = "";

  @override
  void initState() {
    super.initState();
  }

  void _translateCurrentScreen() {
    _showHomeOverlay();
    // _takeScreenShot();
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _showHomeOverlay() async {
    await FlutterOverlayWindow.moveOverlay(const OverlayPosition(10, 25));
    await FlutterOverlayWindow.resizeOverlay(400, 875, true);
  }

  Future<void> _takeScreenShot() async {
    try {
      final boundary = previewContainer.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage();

      final directory = (await getApplicationDocumentsDirectory()).path;

      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        final imgFile = File('$directory/screenshot.png');
        await imgFile.writeAsBytes(pngBytes);

        await _recognizingText(InputImage.fromFile(imgFile));
      } else {
        print('Failed to convert image to bytes.');
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> _recognizingText(InputImage img) async {
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(img);

    setState(() {
      _sourceText = recognizedText.text;
    });

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // RepaintBoundary(
          //   key: previewContainer,
          //   child: const Center(
          //     child: Text('This is the content to capture.',
          //         style: TextStyle(fontSize: 24)),
          //   ),
          // ),
          Positioned.fill(
              child: Container(
                  color: Colors.white,
                  child: LanguageChangedBox(
                      sourceLanguage: languages[0],
                      targetLanguage: languages[1])
                  // HomePage(
                  //     sourceText: _sourceText,
                  //     sourceLanguage: languages[0],
                  //     targetLanguage: languages[1])
                  )),
          Positioned(
            child: ClipOval(
              child: Center(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: FloatingActionButton(
                  onPressed: _translateCurrentScreen,
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(
                    Icons.translate,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
