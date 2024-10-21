import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'prayer.dart';
import 'calculation.dart';
import 'package:adhan/adhan.dart';
import 'get_city_name.dart'; // Import the function for city and country retrieval

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await updatePrayerTimesIfNeeded();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  // Schedule the background task
  Workmanager().registerPeriodicTask(
    "1",
    "updatePrayerTimes",
    frequency: const Duration(hours: 24),
  );

  runApp(Athan());
}

class Athan extends StatelessWidget {
  const Athan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkAndUpdateLocation();
  }

  // Pages for the bottom navigation bar tabs
  final List<Widget> _pages = [
    const PrayerPage(),
    const PlaceholderWidget(text: 'Qibla'),
    const PlaceholderWidget(text: 'Calendar'),
    const PlaceholderWidget(text: 'Mosques'),
    CalculationPage(),
  ];

  Future<void> _checkAndUpdateLocation() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastUpdated = prefs.getString('lastUpdated');
    String today = DateTime.now().toString().split(' ')[0];

    if (lastUpdated != today) {
      await _requestLocationPermission();
      await prefs.setString('lastUpdated', today);
      await updatePrayerTimesIfNeeded();
    } else {
      print('Location already updated today.');
    }
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus permission = await Permission.location.request();

    if (permission.isGranted) {
      print('Fine location permission granted.');
      await _getFineLocation();
    } else {
      print('Fine location permission denied. Using IP geolocation.');
      await _getApproximateLocation();
    }
  }

  Future<void> _getFineLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', position.latitude);
    prefs.setDouble('longitude', position.longitude);

    // Fetch city and country using the new function
    Map<String, String> locationData = await getCityAndCountry(position.latitude, position.longitude);
    String city = locationData['city']!;
    String country = locationData['country']!;

    // Save the city and country in shared preferences
    prefs.setString('city', city);
    prefs.setString('country', country);

    print('City name before saving: $city');
    print('Country name before saving: $country');

    // Retrieve and print the saved city and country
    String? savedCity = prefs.getString('city');
    String? savedCountry = prefs.getString('country');

    print('Saved city name: $savedCity');
    print('Saved country name: $savedCountry');
  }

  Future<void> _getApproximateLocation() async {
    final response = await http.get(Uri.parse('http://ip-api.com/json'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      double latitude = data['lat'];
      double longitude = data['lon'];
      String city = data['city'] ?? 'Unknown City';

      final prefs = await SharedPreferences.getInstance();
      prefs.setDouble('latitude', latitude);
      prefs.setDouble('longitude', longitude);

      // Fetch city and country using the new function
      Map<String, String> locationData = await getCityAndCountry(latitude, longitude);
      String fetchedCity = locationData['city']!;
      String fetchedCountry = locationData['country']!;

      prefs.setString('city', fetchedCity);
      prefs.setString('country', fetchedCountry);

      print('Approximate location saved: Lat=$latitude, Lon=$longitude, City=$fetchedCity, Country=$fetchedCountry');
    } else {
      print('Error fetching IP geolocation.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.personPraying),
            label: 'Prayer',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.kaaba),
            label: 'Qibla',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.calendarDays),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.mosque),
            label: 'Mosques',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.calculator),
            label: 'Calculation',
          ),
        ],
      ),
    );
  }
}

// Placeholder widget for unimplemented pages
class PlaceholderWidget extends StatelessWidget {
  final String text;
  const PlaceholderWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$text Page',
        style: const TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}

Future<void> updatePrayerTimesIfNeeded() async {
  final prefs = await SharedPreferences.getInstance();
  double? latitude = prefs.getDouble('latitude');
  double? longitude = prefs.getDouble('longitude');
  String? lastUpdateDate = prefs.getString('lastUpdated');

  // Fetch the selected method from SharedPreferences
  String selectedMethod = prefs.getString('selectedMethod') ?? 'Muslim World League';

  bool needsDailyUpdate = lastUpdateDate != DateTime.now().toString().split(' ')[0];

  if (latitude != null && longitude != null && needsDailyUpdate) {
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

// Function to pull the selected method for prayer time calculation
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
