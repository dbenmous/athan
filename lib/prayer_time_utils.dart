// prayer_time_utils.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

Future<void> updatePrayerTimesIfNeeded() async {
  final prefs = await SharedPreferences.getInstance();
  double? latitude = prefs.getDouble('latitude');
  double? longitude = prefs.getDouble('longitude');
  String? lastUpdateDate = prefs.getString('lastUpdated');

  // Fetch the selected method from SharedPreferences
  String selectedMethod = prefs.getString('selectedMethod') ?? 'Muslim World League';

  bool needsDailyUpdate = lastUpdateDate != DateFormat('yyyy-MM-dd').format(DateTime.now());

  if (latitude != null && longitude != null) {
    await calculateAndSavePrayerTimes(latitude, longitude, selectedMethod);
  }
}

Future<void> calculateAndSavePrayerTimes(double latitude, double longitude, String selectedMethod) async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, List<String>> monthlyPrayerTimes = {};

  for (int i = 0; i < 30; i++) {
    DateTime date = DateTime.now().add(Duration(days: i));
    final dateComponents = DateComponents.from(date);

    CalculationParameters params = getCalculationMethod(selectedMethod);

    final coordinates = Coordinates(latitude, longitude);
    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

    monthlyPrayerTimes[DateFormat('yyyy-MM-dd').format(date)] = [
      DateFormat.Hm().format(prayerTimes.fajr),
      DateFormat.Hm().format(prayerTimes.sunrise),
      DateFormat.Hm().format(prayerTimes.dhuhr),
      DateFormat.Hm().format(prayerTimes.asr),
      DateFormat.Hm().format(prayerTimes.maghrib),
      DateFormat.Hm().format(prayerTimes.isha),
    ];
  }

  prefs.setString('monthlyPrayerTimes', jsonEncode(monthlyPrayerTimes));
  print('Prayer times for the next month saved in SharedPreferences.');
}

CalculationParameters getCalculationMethod(String selectedMethod) {
  switch (selectedMethod) {
    case 'Muslim World League':
      return CalculationMethod.muslim_world_league.getParameters();
    case 'Egyptian General Authority of Survey':
      return CalculationParameters(fajrAngle: 19.5, ishaAngle: 17.5);
    case 'University of Islamic Sciences, Karachi':
      return CalculationParameters(fajrAngle: 18.0, ishaAngle: 18.0);
    case 'Umm al-Qura University, Makkah':
      return CalculationMethod.umm_al_qura.getParameters();
    case 'Dubai':
      return CalculationParameters(fajrAngle: 18.2, ishaAngle: 18.2);
    case 'North America (ISNA)':
      return CalculationMethod.north_america.getParameters();
    default:
      return CalculationMethod.muslim_world_league.getParameters();
  }
}
