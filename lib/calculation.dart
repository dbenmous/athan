import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class CalculationPage extends StatefulWidget {
  const CalculationPage({Key? key}) : super(key: key);

  @override
  CalculationPageState createState() => CalculationPageState();
}

class CalculationPageState extends State<CalculationPage> {
  String? city;
  String? country;
  List<Prayer> prayerTimes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStoredPrayerTimes(); // Load stored times first
    _getLocationAndDisplayCityCountry(); // Get and display city and country
  }

  // Load stored prayer times immediately without waiting for recalculation
  Future<void> _loadStoredPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? prayerTimesString = prefs.getString('monthlyPrayerTimes');

    if (prayerTimesString != null) {
      Map<String, dynamic> savedTimes = jsonDecode(prayerTimesString);
      if (savedTimes.containsKey(todayDate)) {
        List<String> todayPrayerTimes = List<String>.from(savedTimes[todayDate]);

        // Immediately show the saved prayer times
        setState(() {
          prayerTimes = [
            Prayer(name: 'Fajr', time: DateFormat.Hm().parse(todayPrayerTimes[0])),
            Prayer(name: 'Sunrise', time: DateFormat.Hm().parse(todayPrayerTimes[1])),
            Prayer(name: 'Dhuhr', time: DateFormat.Hm().parse(todayPrayerTimes[2])),
            Prayer(name: 'Asr', time: DateFormat.Hm().parse(todayPrayerTimes[3])),
            Prayer(name: 'Maghrib', time: DateFormat.Hm().parse(todayPrayerTimes[4])),
            Prayer(name: 'Isha', time: DateFormat.Hm().parse(todayPrayerTimes[5])),
          ];
          isLoading = false;
        });
      }
    }
  }

  // Get location and try to display the city and country
  Future<void> _getLocationAndDisplayCityCountry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double? latitude = prefs.getDouble('latitude');
      double? longitude = prefs.getDouble('longitude');

      if (latitude != null && longitude != null) {
        // Use reverse geocoding to get the city and country
        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks[0];

        setState(() {
          city = place.locality ?? 'Unknown';
          country = place.country ?? 'Unknown';
        });
      } else {
        setState(() {
          city = "Location not available";
          country = "Location not available";
        });
      }
    } catch (e) {
      print('Error fetching city and country: $e');
      setState(() {
        city = "Error";
        country = "Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prayer Time Calculation',
          style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Spinner when loading
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Country: ${country ?? 'Loading...'}',
              style: const TextStyle(fontFamily: 'Lato', fontSize: 18),
            ),
            Text(
              'City: ${city ?? 'Loading...'}',
              style: const TextStyle(fontFamily: 'Lato', fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Prayer Times for Today:',
              style: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            prayerTimes.isEmpty
                ? const Center(child: CircularProgressIndicator()) // Spinner when empty
                : Expanded(
              child: ListView.builder(
                itemCount: prayerTimes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      prayerTimes[index].name,
                      style: const TextStyle(fontFamily: 'Lato', fontSize: 18),
                    ),
                    trailing: Text(
                      formatTime(prayerTimes[index].time),
                      style: const TextStyle(fontFamily: 'Lato', fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}

class Prayer {
  final String name;
  final DateTime time;

  Prayer({required this.name, required this.time});
}
