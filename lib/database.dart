import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "translate_app.db");
    if (kDebugMode) {
      print('Database path: $path');
    }
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username VARCHAR(50) NOT NULL,
          email VARCHAR(100) NOT NULL,
          password VARCHAR(255) NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');

        await db.execute('''
        CREATE TABLE translations (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          source_text TEXT NOT NULL,
          source_language VARCHAR(5) NOT NULL,
          translated_text TEXT NOT NULL,
          target_language VARCHAR(5) NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');

        await db.execute('''
        CREATE TABLE favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          translation_id INTEGER,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
          FOREIGN KEY (translation_id) REFERENCES translations(id) ON DELETE CASCADE
        )
      ''');
      },
    );
  }
}
