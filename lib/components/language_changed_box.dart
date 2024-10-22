import 'package:flutter/material.dart';
import 'package:translation_app/constants/languages.dart';

class LanguageChangedBox extends StatefulWidget {
  final Language sourceLanguage;
  final Language targetLanguage;

  const LanguageChangedBox(
      {super.key, required this.sourceLanguage, required this.targetLanguage});

  @override
  _LanguageChangedBoxState createState() => _LanguageChangedBoxState();
}

class _LanguageChangedBoxState extends State<LanguageChangedBox> {
  late final Language _sourceLanguage;
  late final Language _targetLanguage;

  @override
  void initState() {
    super.initState();

    _sourceLanguage = widget.sourceLanguage;
    _targetLanguage = widget.targetLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 251, 254, 1),
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            _sourceLanguage.img,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<Language>(
              value: _sourceLanguage,
              onChanged: (newValue) {
                setState(() {
                  if (newValue != null &&
                      _targetLanguage.code == newValue.code) {
                    _targetLanguage = _sourceLanguage;
                  }
                  _sourceLanguage = newValue!;
                });
              },
              items: languages.map((language) {
                return DropdownMenuItem<Language>(
                  value: language,
                  child: Text(
                    language.name,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              isExpanded: true,
              underline: Container(
                height: 1,
                color: Colors.grey[400],
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: () {
              setState(() {
                final temp = _sourceLanguage;
                _sourceLanguage = _targetLanguage;
                _targetLanguage = temp;
              });
            },
            child: const Icon(Icons.swap_horiz, size: 24),
          ),
          const SizedBox(width: 16),
          Image.asset(
            _targetLanguage.img,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<Language>(
              value: _targetLanguage,
              onChanged: (newValue) {
                setState(() {
                  if (newValue != null && _sourceLanguage == newValue) {
                    _sourceLanguage = _targetLanguage;
                  }
                  _targetLanguage = newValue!;
                });
              },
              items: languages.map((language) {
                return DropdownMenuItem<Language>(
                  value: language,
                  child: Text(
                    language.name,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              isExpanded: true,
              underline: Container(
                height: 1,
                color: Colors.grey[400],
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
