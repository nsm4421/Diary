enum Country {
  korea(
    countryCode: 'KR',
    languageCode: 'ko',
    englishName: 'Korea',
    nativeName: '대한민국',
  ),
  unitedStates(
    countryCode: 'US',
    languageCode: 'en',
    englishName: 'United States',
    nativeName: 'United States',
  ),
  japan(
    countryCode: 'JP',
    languageCode: 'ja',
    englishName: 'Japan',
    nativeName: '日本',
  );

  const Country({
    required this.countryCode,
    required this.languageCode,
    required this.englishName,
    required this.nativeName,
  });

  final String countryCode;
  final String languageCode;
  final String englishName;
  final String nativeName;
}
