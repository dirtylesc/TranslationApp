class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final DateTime createdAt;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  // Chuyển từ Map (SQLite) thành đối tượng User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Chuyển đối tượng User thành Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
