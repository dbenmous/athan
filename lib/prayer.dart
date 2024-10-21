import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'duae.dart';
import 'prayer_widgets.dart';
import 'settings.dart';
import 'get_city_name.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  int currentPage = 0;
  List<bool> viewedStories = List.generate(7, (index) => false);
  String cityName = 'Loading...';
  String countryName = '';
  List<Prayer> prayerTimes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCityAndCountry();
    _loadStoredPrayerTimes();
    DateTime now = DateTime.now();
    currentPage = now.day % duaes.length;
  }

  Future<void> _loadCityAndCountry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double? latitude = prefs.getDouble('latitude');
      double? longitude = prefs.getDouble('longitude');

      if (latitude != null && longitude != null) {
        Map<String, String> locationData = await getCityAndCountry(latitude, longitude);
        setState(() {
          cityName = locationData['city'] ?? 'City Not Found';
          countryName = locationData['country'] ?? 'Country Not Found';
        });
      } else {
        setState(() {
          cityName = 'Location not available';
          countryName = 'Location not available';
        });
      }
    } catch (e) {
      print('Error loading city and country: $e');
      setState(() {
        cityName = 'Error Finding City';
        countryName = 'Error Finding Country';
      });
    }
  }

  Future<void> _loadStoredPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? prayerTimesString = prefs.getString('monthlyPrayerTimes');

    if (prayerTimesString != null) {
      Map<String, dynamic> savedTimes = jsonDecode(prayerTimesString);
      if (savedTimes.containsKey(todayDate)) {
        List<String> todayPrayerTimes = List<String>.from(savedTimes[todayDate]);

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
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/prayer_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE5ECED),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SettingsPage()),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildNextPrayerSection(),
                    const SizedBox(height: 20),
                    _buildDateSection(),
                    const SizedBox(height: 20),
                    buildStoriesSection(viewedStories, context),
                    const SizedBox(height: 20),
                    _buildLocationSection(),
                    const SizedBox(height: 20),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildPrayerTimes(),
                    const SizedBox(height: 30),
                    buildSwipeableDuaeSection(currentPage, (index) {
                      setState(() {
                        currentPage = index;
                      });
                    }, duaes),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerSection() {
    String timeRemaining = '1h 23m';
    String nextPrayerTime = '18:30';
    String nextPrayerName = 'Isha';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Next Prayer in $timeRemaining',
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 20,
            color: Color(0xFFE5ECED),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '$nextPrayerName at $nextPrayerTime',
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    String hijriDate = '1 Muharram 1446';
    String gregorianDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hijriDate,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 16,
            color: Color(0xFFB0C4DE),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          gregorianDate,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 16,
            color: Color(0xFFB0C4DE),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Row(
      children: [
        const Icon(
          FontAwesomeIcons.locationDot,
          size: 24,
          color: Color(0xFFB0C4DE),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            '$cityName, $countryName',
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 22,
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerTimes() {
    return Column(
      children: prayerTimes.map((prayer) {
        return buildPrayerWidget(
          prayer.name,
          DateFormat.Hm().format(prayer.time),
          true, // Sound status; adjust as needed
          false, // Highlighting status; adjust as needed
        );
      }).toList(),
    );
  }
}

class Prayer {
  final String name;
  final DateTime time;

  Prayer({required this.name, required this.time});
}
