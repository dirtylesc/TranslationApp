import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:translation_app/text_to_speech.dart';

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
  String _translatedText = '';
  bool _isTranslated = false;

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'img': 'images/united-states-flag.png', 'code': 'en'},
    {'name': 'Tiếng Việt', 'img': 'images/vietnam-flag.png', 'code': 'vi'},
    {'name': '한글', 'img': 'images/korean-flag.png', 'code': 'ko'},
    // Add more languages if needed
  ];

  late Map<String, String> _sourceLanguage = _languages[0];
  late Map<String, String> _targetLanguage = _languages[1];

  Future<void> _translateText(String text) async {
    setState(() {
      _isTranslated = false;
    });

    final apiUrl =
        'https://api.mymemory.translated.net/get?q=$text&langpair=${_sourceLanguage['code']}|${_targetLanguage['code']}';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load translation');
    }

    final data = json.decode(response.body);

    String bestTranslation = data['responseData']['translatedText'];
    if (bestTranslation.contains("object")) {
      num highestMatchScore = 0;

      if (data['matches'] != null) {
        for (var match in data['matches']) {
          if (bestTranslation.contains("object") ||
              match['match'] > highestMatchScore) {
            highestMatchScore = match['match'];
            bestTranslation = match['translation'];
          }
        }
      }
    }

    setState(() {
      _translatedText = bestTranslation;
      _isTranslated = true;
    });
  }

  Future<void> _voiceText(String text, String? language) async {
    if (language == null) return;

    await TTSExample(text: text, language: language).speak();
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
                        width: 24, // Set width for flag images
                        height: 24, // Set height for flag images
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
                                  fontSize: 16, // Font size for dropdown items
                                ),
                              ),
                            );
                          }).toList(),
                          isExpanded:
                              true, // Make dropdown expand to fill available space
                          underline: Container(
                            height: 1,
                            color: Colors.grey[400], // Color of the underline
                          ),
                          style: const TextStyle(
                            color: Colors.black, // Color of the selected item
                            fontSize: 16, // Font size of the selected item
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
                        width: 24, // Set width for flag images
                        height: 24, // Set height for flag images
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
                                  fontSize: 16, // Font size for dropdown items
                                ),
                              ),
                            );
                          }).toList(),
                          isExpanded:
                              true, // Make dropdown expand to fill available space
                          underline: Container(
                            height: 1,
                            color: Colors.grey[400], // Color of the underline
                          ),
                          style: const TextStyle(
                            color: Colors.black, // Color of the selected item
                            fontSize: 16, // Font size of the selected item
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
                                onPressed: () => {
                                  _voiceText(_sourcecInputController.text,
                                      _sourceLanguage['code'])
                                },
                              )
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              // Thêm chức năng đóng giao diện
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
                              // Thêm chức năng nhận diện giọng nói
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(0, 51, 102, 1),
                                  borderRadius: BorderRadius.circular(100)),
                              child: const Icon(
                                color: Colors.white,
                                Icons.mic,
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
                                        _targetLanguage['code'])
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
                              icon: const Icon(Icons.star_border_outlined),
                              onPressed: () => {},
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
