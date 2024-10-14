import 'package:flutter/material.dart';

import 'package:translation_app/splash.dart';
import 'package:translation_app/Database.dart';
import 'package:translation_app/layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await DBProvider.db.database;
  // Kiểm tra xem database đã mở thành công chưa
  if (database != null) {
    print("Database initialized successfully.");
  } else {
    print("Database initialization failed.");
  }

  return runApp(const TranslationApp());
}

class TranslationApp extends StatelessWidget {
  const TranslationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translation App',
      initialRoute: '/splash', // Đặt Splash là trang đầu tiên
      routes: {
        '/splash': (context) => const SplashPage(),
        '/appLayout': (context) => const AppLayout(),
      },
    );
  }
}
