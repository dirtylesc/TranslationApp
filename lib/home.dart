import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translation_app/database.dart';
import 'package:translation_app/speech_to_text.dart';

import 'package:translation_app/text_to_speech.dart';
import 'package:translator/translator.dart';

void main() => runApp(const HomePage());

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TranslationHome(),
      ),
    );
  }
}

class TranslationHome extends StatefulWidget {
  const TranslationHome({super.key});

  @override
  _TranslationHomeState createState() => _TranslationHomeState();
}

class _TranslationHomeState extends State<TranslationHome> {
  final TextEditingController _sourcecInputController = TextEditingController();
  final translator = GoogleTranslator();
  final TTS _flutterTTS = TTS();
  final STT _flutterSTT = STT();

  String _translatedText = '';
  late Map<String, dynamic> _currentTranslation;
  bool _isTranslated = false;
  bool _isVoiceStarting = false;

  final List<Map<String, String>> _languages = [
    {
      'name': 'English',
      'img': 'images/united-states-flag.png',
      'code': 'en',
      'language': 'en-US'
    },
    {
      'name': 'Tiếng Việt',
      'img': 'images/vietnam-flag.png',
      'code': 'vi',
      'language': 'vi-VN'
    },
    {
      'name': '한글',
      'img': 'images/korean-flag.png',
      'code': 'ko',
      'language': 'ko-KR'
    },
  ];

  late Map<String, String> _sourceLanguage = _languages[0];
  late Map<String, String> _targetLanguage = _languages[1];

  Future<void> _translateText(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _isTranslated = false;
    });

    var translation = await translator.translate(_sourcecInputController.text,
        from: _sourceLanguage['code']!, to: _targetLanguage['code']!);

    String bestTranslation = translation.text;

    int id = await DBProvider.db.insertTranslation({
      'user_id': 123,
      'source_text': _sourcecInputController.text,
      'source_language': _sourceLanguage['code'],
      'translated_text': bestTranslation,
      'target_language': _targetLanguage['code'],
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

  Future<void> _textVoice() async {
    setState(() {
      _isVoiceStarting = !_isVoiceStarting;
    });

    await _flutterSTT.startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 251, 254, 1),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        _sourceLanguage['img']!,
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<Map<String, String>>(
                          value: _sourceLanguage,
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue != null &&
                                  _targetLanguage['code'] == newValue['code']) {
                                _targetLanguage = _sourceLanguage;
                                _sourcecInputController.text = _translatedText;
                              }
                              _sourceLanguage = newValue!;
                              _translateText(_translatedText);
                            });
                          },
                          items: _languages.map((language) {
                            return DropdownMenuItem<Map<String, String>>(
                              value: language,
                              child: Text(
                                language['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                          isExpanded: true,
                          underline: Container(
                            height: 1,
                            color: Colors.grey[400],
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          setState(() {
                            final temp = _sourceLanguage;
                            _sourceLanguage = _targetLanguage;
                            _targetLanguage = temp;

                            _sourcecInputController.text = _translatedText;
                            _translateText(_translatedText);
                          });
                        },
                        child: const Icon(Icons.swap_horiz, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Image.asset(
                        _targetLanguage['img']!,
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<Map<String, String>>(
                          value: _targetLanguage,
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue != null &&
                                  _sourceLanguage == newValue) {
                                _sourceLanguage = _targetLanguage;
                                _sourcecInputController.text = _translatedText;
                              }
                              _targetLanguage = newValue!;
                              _translateText(_translatedText);
                            });
                          },
                          items: _languages.map((language) {
                            return DropdownMenuItem<Map<String, String>>(
                              value: language,
                              child: Text(
                                language['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                          isExpanded: true,
                          underline: Container(
                            height: 1,
                            color: Colors.grey[400],
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                              Text(_sourceLanguage['name']!,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 51, 102, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 4),
                              IconButton(
                                  color: const Color.fromRGBO(0, 51, 102, 1),
                                  icon: const Icon(Icons.volume_down_outlined),
                                  onPressed: () {
                                    _voiceText(_sourcecInputController.text,
                                        _sourceLanguage['language']);
                                  })
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              if (_sourcecInputController.text.isNotEmpty) {
                                _sourcecInputController.clear();
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
                        controller: _sourcecInputController,
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
                          InkWell(
                            onTap: () {
                              _textVoice();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: _isVoiceStarting
                                      ? Colors.red
                                      : Color.fromRGBO(0, 51, 102, 1),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                color: Colors.white,
                                _isVoiceStarting ? Icons.square : Icons.mic,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _translateText(_sourcecInputController.text);
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
                                Text(_targetLanguage['name']!,
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
                                        _targetLanguage['language'])
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
