import 'package:flutter/material.dart';
import 'package:translation_app/layouts/layout.dart';
import 'package:translation_app/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
