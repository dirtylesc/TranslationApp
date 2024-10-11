class Favorite {
  final int? id;
  final int userId;
  final int translationId;
  final DateTime createdAt;

  Favorite({
    this.id,
    required this.userId,
    required this.translationId,
    required this.createdAt,
  });

  // Chuyển từ Map thành đối tượng Favorite
  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'],
      userId: map['user_id'],
      translationId: map['translation_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Chuyển đối tượng Favorite thành Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'translation_id': translationId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
