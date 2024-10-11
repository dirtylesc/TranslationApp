class Translation {
  final int? id;
  final int userId;
  final String sourceText;
  final String sourceLanguage;
  final String translatedText;
  final String targetLanguage;
  final DateTime createdAt;

  Translation({
    this.id,
    required this.userId,
    required this.sourceText,
    required this.sourceLanguage,
    required this.translatedText,
    required this.targetLanguage,
    required this.createdAt,
  });

  // Chuyển từ Map thành đối tượng Translation
  factory Translation.fromMap(Map<String, dynamic> map) {
    return Translation(
      id: map['id'],
      userId: map['user_id'],
      sourceText: map['source_text'],
      sourceLanguage: map['source_language'],
      translatedText: map['translated_text'],
      targetLanguage: map['target_language'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Chuyển đối tượng Translation thành Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'source_text': sourceText,
      'source_language': sourceLanguage,
      'translated_text': translatedText,
      'target_language': targetLanguage,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
