import 'package:flutter/material.dart';

class LanguageTextRow extends StatelessWidget {
  final String code;
  final String text;
  final bool isTranslatedText;

  const LanguageTextRow({
    required this.code,
    required this.text,
    required this.isTranslatedText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            code,
            style: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: TextStyle(
              color: isTranslatedText
                  ? const Color.fromRGBO(255, 102, 0, 1)
                  : const Color.fromRGBO(0, 51, 102, 1),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: isTranslatedText ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
