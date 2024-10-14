import 'package:flutter/material.dart';
import 'package:translation_app/database.dart';

void main() => runApp(const HistoryPage());

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> translations = [];

  Future<void> _loadTranslations() async {
    const userId = 123;
    translations =
        (await DBProvider.db.getTranslations(userId)).reversed.toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: translations.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No translation history',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loadTranslations,
                      child: const Text('Reload'),
                    ),
                  ],
                ),
              )
            : Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _loadTranslations,
                    child: const Text('Reload'),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: translations.length,
                        itemBuilder: (context, index) {
                          final translation = translations[index];

                          return Card(
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LanguageTextRow(
                                        code: translation['source_language'],
                                        text: translation['source_text'],
                                        isTranslatedText: false,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      const Divider(
                                        color: Color.fromRGBO(150, 150, 150, 1),
                                        thickness: 1,
                                        height: 1,
                                        indent: 16,
                                        endIndent: 16,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      LanguageTextRow(
                                        code: translation['target_language'],
                                        text: translation['translated_text'],
                                        isTranslatedText: true,
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.star,
                                        color: Color.fromRGBO(0, 51, 102,
                                            1), // Use your preferred color
                                      ),
                                      onPressed: () {},
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }))
              ]));
  }
}

class LanguageTextRow extends StatelessWidget {
  final String code;
  final String text;
  final bool isTranslatedText;

  const LanguageTextRow({
    required this.code,
    required this.text,
    required this.isTranslatedText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: const TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          text,
          style: TextStyle(
            color: isTranslatedText
                ? const Color.fromRGBO(255, 102, 0, 1)
                : const Color.fromRGBO(0, 51, 102, 1),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: isTranslatedText ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }
}
