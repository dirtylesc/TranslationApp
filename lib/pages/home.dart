import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translation_app/components/language_changed_box.dart';
import 'package:translation_app/components/speech_to_text.dart';
import 'package:translation_app/components/text_to_speech.dart';
import 'package:translation_app/constants/languages.dart';
import 'package:translation_app/database.dart';
import 'package:translator/translator.dart';

class HomePage extends StatefulWidget {
  final String sourceText;
  final Language sourceLanguage;
  final Language targetLanguage;

  const HomePage(
      {super.key,
      this.sourceText = "",
      required this.sourceLanguage,
      required this.targetLanguage});

  @override
  _TranslationHomeState createState() => _TranslationHomeState();
}

class _TranslationHomeState extends State<HomePage> {
  final TextEditingController _sourceInputController = TextEditingController();
  final translator = GoogleTranslator();
  final TTS _flutterTTS = TTS();

  String _translatedText = '';
  late Map<String, dynamic> _currentTranslation;
  bool _isTranslated = false;

  late Language _sourceLanguage = languages[0];
  late Language _targetLanguage = languages[1];

  @override
  void initState() {
    super.initState();

    _sourceLanguage = widget.sourceLanguage;
    _targetLanguage = widget.targetLanguage;
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _sourceInputController.text = widget.sourceText;
      _sourceLanguage = widget.sourceLanguage;
      _targetLanguage = widget.targetLanguage;
      _translateText(widget.sourceText);
    });
  }

  Future<void> _translateText(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _isTranslated = false;
    });

    var translation = await translator.translate(_sourceInputController.text,
        from: _sourceLanguage.code, to: _targetLanguage.code);

    String bestTranslation = translation.text;

    int id = await DBProvider.db.insertTranslation({
      'source_text': _sourceInputController.text,
      'source_language': _sourceLanguage.code,
      'translated_text': bestTranslation,
      'target_language': _targetLanguage.code,
    });

    _currentTranslation = (await DBProvider.db.getTranslation(id))!;

    setState(() {
      _translatedText = bestTranslation;
      _isTranslated = true;
    });
  }

  Future<void> _updateMarkTranslation() async {
    if (_currentTranslation.isEmpty) return;

    int id = await DBProvider.db.updateTranslation(_currentTranslation['id'], {
      ..._currentTranslation,
      'is_marked': _currentTranslation['is_marked'] == 1 ? 0 : 1
    });

    if (id > 0) {
      setState(() {
        _currentTranslation = {
          ..._currentTranslation,
          'is_marked': _currentTranslation['is_marked'] == 1 ? 0 : 1
        };
      });
    }
  }

  Future<void> _voiceText(String text, String? language) async {
    final isPlaying = _flutterTTS.isPlaying;

    if (isPlaying) {
      await _flutterTTS.stop();

      if (_flutterTTS.prevLanguage == language) {
        return;
      }
    }

    if (language == null || text.isEmpty) return;
    await _flutterTTS.speak(text, language);
  }

  Future<void> _handleTextChanged(String newText) async {
    setState(() {
      _sourceInputController.text = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                LanguageChangedBox(
                    sourceLanguage: _sourceLanguage,
                    targetLanguage: _targetLanguage),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 251, 254, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(_sourceLanguage.name,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 51, 102, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 4),
                              IconButton(
                                  color: const Color.fromRGBO(0, 51, 102, 1),
                                  icon: const Icon(Icons.volume_down_outlined),
                                  onPressed: () {
                                    _voiceText(_sourceInputController.text,
                                        _sourceLanguage.language);
                                  })
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              if (_sourceInputController.text.isNotEmpty) {
                                _sourceInputController.clear();
                              }

                              setState(() {
                                _isTranslated = false;
                                _translatedText = "";
                              });
                            },
                          ),
                        ],
                      ),
                      TextField(
                        controller: _sourceInputController,
                        maxLines: null,
                        minLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Enter text here...',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stt(
                            onListened: _handleTextChanged,
                            onStopped: () =>
                                _translateText(_sourceInputController.text),
                            sourceLanguage: _sourceLanguage.language,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _translateText(_sourceInputController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(255, 102, 0, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: const Text(
                              'Translate',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_isTranslated)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 251, 254, 1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(_targetLanguage.name,
                                    style: const TextStyle(
                                        color: Color.fromRGBO(0, 51, 102, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 4),
                                IconButton(
                                  color: const Color.fromRGBO(0, 51, 102, 1),
                                  icon: const Icon(Icons.volume_down_outlined),
                                  onPressed: () => {
                                    _voiceText(_translatedText,
                                        _targetLanguage.language)
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                        TextField(
                          maxLines: null,
                          minLines: 3,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: _translatedText,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              color: const Color.fromRGBO(0, 51, 102, 1),
                              icon: const Icon(Icons.copy),
                              onPressed: () => {
                                Clipboard.setData(
                                        ClipboardData(text: _translatedText))
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Copied to clipboard!'),
                                    ),
                                  );
                                })
                              },
                            ),
                            IconButton(
                              color: const Color.fromRGBO(0, 51, 102, 1),
                              icon: Icon(
                                _currentTranslation['is_marked'] == 1
                                    ? Icons.star
                                    : Icons.star_outline,
                              ),
                              onPressed: () => {_updateMarkTranslation()},
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}
