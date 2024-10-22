import 'package:intl/intl.dart';

class Prayer {
  final String name;
  final DateTime time;

  Prayer({required this.name, required this.time});
}

// Function to determine the next prayer
Prayer getNextPrayer(List<Prayer> prayerTimes) {
  DateTime now = DateTime.now();
  for (Prayer prayer in prayerTimes) {
    if (prayer.time.isAfter(now)) {
      return prayer;
    }
  }
  // If no prayer is left for today, return the first prayer of the next day
  DateTime nextDayPrayerTime = prayerTimes[0].time.add(const Duration(days: 1));
  return Prayer(name: prayerTimes[0].name, time: nextDayPrayerTime);
}

// Function to get the time remaining until the next prayer
String getTimeRemaining(DateTime nextPrayerTime) {
  DateTime now = DateTime.now();
  Duration difference = nextPrayerTime.difference(now);

  int hours = difference.inHours;
  int minutes = difference.inMinutes % 60;

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else {
    return '${minutes}m';
  }
}

// Function to format the time of the next prayer
String formatPrayerTime(DateTime prayerTime) {
  return DateFormat.Hm().format(prayerTime);
}
