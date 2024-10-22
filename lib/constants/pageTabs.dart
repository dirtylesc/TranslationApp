import 'package:flutter/material.dart';
import 'package:translation_app/pages/camera.dart';
import 'package:translation_app/constants/languages.dart';
import 'package:translation_app/pages/home.dart';

class PageTab {
  final int key;
  final Widget page;

  PageTab({required this.key, required this.page});
}

PageTab homePageTab(
    String sourceText, Language sourceLanguage, Language targetLanguage) {
  return PageTab(
    key: 0,
    page: HomePage(
      sourceText: sourceText,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    ),
  );
}

PageTab cameraPageTab(Function(String, Language, Language) navigateToHome) {
  return PageTab(
    key: 0,
    page: CameraPage(navigateToHome: navigateToHome),
  );
}

PageTab logoPageTab() {
  return PageTab(
    key: 0,
    page: const SizedBox(),
  );
}
