import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final TextEditingController _inputController = TextEditingController();
  String _translatedText = '';
  String _sourceLanguage = 'en';
  String _targetLanguage = 'vi';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Vietnamese', 'code': 'vi'},
    {'name': '한글', 'code': 'ko'},
    // {'name': 'Spanish', 'code': 'es'},
    // {'name': 'French', 'code': 'fr'},
    // {'name': 'Chinese', 'code': 'zh-CN'},
  ];

  Future<void> _translateText(String text) async {
    final apiUrl =
        'https://api.mymemory.translated.net/get?q=$text&langpair=$_sourceLanguage|$_targetLanguage';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _translatedText = data['responseData']['translatedText'];
      });
    } else {
      throw Exception('Failed to load translation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField để nhập văn bản
            TextField(
              controller: _inputController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter text to translate',
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _sourceLanguage,
                    onChanged: (newValue) {
                      setState(() {
                        _sourceLanguage = newValue!;
                      });
                    },
                    items: _languages.map((language) {
                      return DropdownMenuItem<String>(
                        value: language['code'],
                        child: Text(language['name']!),
                      );
                    }).toList(),
                  ),
                ),
                const Icon(Icons.swap_horiz),
                Expanded(
                  child: DropdownButton<String>(
                    value: _targetLanguage,
                    onChanged: (newValue) {
                      setState(() {
                        _targetLanguage = newValue!;
                      });
                    },
                    items: _languages.map((language) {
                      return DropdownMenuItem<String>(
                        value: language['code'],
                        child: Text(language['name']!),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                _translateText(_inputController.text);
              },
              child: const Text('Translate'),
            ),
            const SizedBox(height: 16),

            Text(
              _translatedText,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
