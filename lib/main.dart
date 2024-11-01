import 'package:flutter/material.dart';
import 'package:translation_app/database.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:translation_app/components/overlay.dart';
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

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrueCallerOverlay(),
    ),
  );
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

    await FlutterOverlayWindow.requestPermission();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "X-SLAYER",
      overlayContent: 'Overlay Enabled',
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      height: (MediaQuery.of(context).size.height * 0.6).toInt(),
      width: WindowSize.matchParent,
      startPosition: const OverlayPosition(0, -259),
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
