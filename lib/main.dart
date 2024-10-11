import 'package:flutter/material.dart';

import 'package:translation_app/splash.dart';
import 'package:translation_app/home.dart';
import 'package:translation_app/camera.dart';
import 'package:translation_app/history.dart';
import 'package:translation_app/favorite.dart';
import 'package:translation_app/layout.dart';

void main() => runApp(const TranslationApp());

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
