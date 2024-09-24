class Hadith {
  final String title;         // Title of the hadith
  final String hadithArabic;  // Arabic text of the hadith
  final String hadithEnglish; // English translation of the hadith
  final String arabicAudio;   // Path to Arabic audio file
  final String englishAudio;  // Path to English audio file

  Hadith({
    required this.title,
    required this.hadithArabic,
    required this.hadithEnglish,
    required this.arabicAudio,
    required this.englishAudio,
  });
}

// List of hadiths
final List<Hadith> hadiths = [
  Hadith(
    title: 'Hadith 1',
    hadithArabic: 'Arabic text of Hadith 1',
    hadithEnglish: 'English translation of Hadith 1',
    arabicAudio: 'assets/audio/hadith1_arabic.mp3',
    englishAudio: 'assets/audio/hadith1_english.mp3',
  ),
  Hadith(
    title: 'Hadith 2',
    hadithArabic: 'Arabic text of Hadith 2',
    hadithEnglish: 'English translation of Hadith 2',
    arabicAudio: 'assets/audio/hadith2_arabic.mp3',
    englishAudio: 'assets/audio/hadith2_english.mp3',
  ),
  // Add more hadiths here
];
