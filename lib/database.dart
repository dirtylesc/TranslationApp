import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    if (io.Platform.isWindows || io.Platform.isLinux || io.Platform.isMacOS) {
      sqfliteFfiInit();

      databaseFactory = databaseFactoryFfi;
    }

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "translate_app.db");
    if (kDebugMode) {
      print('Database path: $path');
    }
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE translations (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          source_text TEXT NOT NULL,
          source_language VARCHAR(5) NOT NULL,
          translated_text TEXT NOT NULL,
          target_language VARCHAR(5) NOT NULL,
          is_marked BOOLEAN DEFAULT FALSE,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');
      },
    );
  }

  Future<Map<String, dynamic>?> getTranslation(int id) async {
    final db = await database;
    return (await db.query('translations', where: 'id = ?', whereArgs: [id]))
        .firstOrNull;
  }

  Future<int> insertTranslation(Map<String, dynamic> translationData) async {
    final db = await database;
    return await db.insert('translations', translationData);
  }

  Future<int> updateTranslation(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db
        .update('translations', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getTranslations() async {
    final db = await database;
    return await db.query('translations');
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db
        .query('translations', where: 'is_marked = ?', whereArgs: [1]);
  }

  Future<void> deleteAllTranslations() async {
    final db = await database;
    await db.delete('translations');
  }
}
