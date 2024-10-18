class Language {
  final String name;
  final String img;
  final String code;
  final String language;

  Language(
      {required this.name,
      required this.img,
      required this.code,
      required this.language});
}

final List<Language> languages = [
  Language(
      name: 'English',
      img: 'images/united-states-flag.png',
      code: 'en',
      language: 'en-US'),
  Language(
      name: 'Tiếng Việt',
      img: 'images/vietnam-flag.png',
      code: 'vi',
      language: 'vi-VN'),
  Language(
      name: '한글', img: 'images/korean-flag.png', code: 'ko', language: 'ko-KR'),
];
