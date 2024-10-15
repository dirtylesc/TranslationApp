class Translation {
  final int? id;
  final String sourceText;
  final String sourceLanguage;
  final String translatedText;
  final String targetLanguage;
  final bool isMarked;
  final DateTime createdAt;

  Translation({
    this.id,
    required this.sourceText,
    required this.sourceLanguage,
    required this.translatedText,
    required this.targetLanguage,
    this.isMarked = false,
    required this.createdAt,
  });

  // Chuyển từ Map thành đối tượng Translation
  factory Translation.fromMap(Map<String, dynamic> map) {
    return Translation(
      id: map['id'],
      sourceText: map['source_text'],
      sourceLanguage: map['source_language'],
      translatedText: map['translated_text'],
      targetLanguage: map['target_language'],
      isMarked: map['is_marked'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Chuyển đối tượng Translation thành Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'source_text': sourceText,
      'source_language': sourceLanguage,
      'translated_text': translatedText,
      'target_language': targetLanguage,
      'is_marked': isMarked ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
