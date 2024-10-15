import 'package:flutter/material.dart';
import 'package:translation_app/components/language_text_row.dart';
import 'package:translation_app/database.dart';

void main() => runApp(const FavoritePage());

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> translations = [];

  Future<void> _loadTranslations() async {
    List<Map<String, dynamic>> loadedTranslations =
        await DBProvider.db.getFavorites();
    setState(() {
      translations = loadedTranslations.reversed.toList();
    });
  }

  Future<void> _updateMarkTranslation(int id, Map<String, dynamic> data) async {
    await DBProvider.db.updateTranslation(
        id, {...data, 'is_marked': data['is_marked'] == 1 ? 0 : 1});

    _loadTranslations();
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
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: () async {
                    await _loadTranslations();
                  },
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
                                vertical: 18, horizontal: 27),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  top: -16,
                                  right: -12,
                                  child: IconButton(
                                    icon: Icon(
                                      translation['is_marked'] == 1
                                          ? Icons.star
                                          : Icons.star_outline,
                                      color: const Color.fromRGBO(0, 51, 102,
                                          1), // Use your preferred color
                                    ),
                                    onPressed: () {
                                      _updateMarkTranslation(
                                          translation['id'], translation);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ))
              ]));
  }
}
