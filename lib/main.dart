import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:translation_app/database.dart';
import 'package:translation_app/layouts/layout.dart';
import 'package:translation_app/pages/splash.dart';
import 'package:translation_app/components/overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool status = await FlutterOverlayWindow.isPermissionGranted();
  if (!status) await FlutterOverlayWindow.requestPermission();
  await DBProvider.db.database;
  return runApp(const TranslationApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: TranslationOverlay()));
}

class TranslationApp extends StatefulWidget {
  const TranslationApp({super.key});

  @override
  State<TranslationApp> createState() => _TranslationAppState();
}

class _TranslationAppState extends State<TranslationApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeOverlay();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _showOverlay();
    } else if (state == AppLifecycleState.resumed) {
      _removeOverlay();
    }
  }

  void _showOverlay() async {
    if (await FlutterOverlayWindow.isActive()) return;
    final bool status = await FlutterOverlayWindow.isPermissionGranted();
    if (!status) {
      await FlutterOverlayWindow.requestPermission();
    }
    final windowSize = window.physicalSize;

    final height = windowSize.height / window.devicePixelRatio;
    await FlutterOverlayWindow.showOverlay(
      alignment: OverlayAlignment.centerRight,
      enableDrag: true,
      overlayTitle: "X-SLAYER",
      overlayContent: 'Overlay Enabled',
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      height: 120,
      width: 120,
      startPosition: OverlayPosition(0, -height / 2 + 50),
    );
  }

  void _removeOverlay() {
    FlutterOverlayWindow.closeOverlay();
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
