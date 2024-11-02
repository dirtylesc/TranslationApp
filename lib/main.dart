import 'package:flutter/material.dart';
import 'package:translation_app/database.dart';
import 'package:translation_app/layouts/layout.dart';
import 'package:translation_app/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBProvider.db.database;
  return runApp(const TranslationApp());
}

class TranslationApp extends StatefulWidget {
  const TranslationApp({super.key});

  @override
  State<TranslationApp> createState() => _TranslationAppState();
}

class _TranslationAppState extends State<TranslationApp>
    with WidgetsBindingObserver {
  @override
  void initState() async {
    super.initState();
  }

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
