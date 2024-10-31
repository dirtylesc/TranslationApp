import 'package:flutter/material.dart';
import 'package:translation_app/database.dart';
import 'package:translation_app/layouts/layout.dart';
import 'package:translation_app/pages/splash.dart';

@pragma("vm:entry-point")
void overlayMain() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(child: Text("My overlay"))));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBProvider.db.database;
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
