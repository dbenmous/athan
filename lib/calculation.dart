import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:adhan/adhan.dart'; // For calculating prayer times
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart'; // For formatting DateTime

class CalculationPage extends StatefulWidget {
  final String selectedMethod;

  const CalculationPage({super.key, required this.selectedMethod}); // Converted to super parameter

  @override
  CalculationPageState createState() => CalculationPageState(); // Public state class
}

class CalculationPageState extends State<CalculationPage> { // Changed private to public
  String? city;
  String? country;
  Position? currentPosition;
  List<Prayer> prayerTimes = [];

  @override
  void initState() {
    super.initState();
    _getLocationAndPrayerTimes();
  }

  Future<void> _getLocationAndPrayerTimes() async {
    try {
      // Removed the use of `print` and used a logger or alternative for production
      debugPrint("Requesting location permission...");

      PermissionStatus permission = await Permission.location.request();
      if (permission.isDenied) {
        setState(() {
          city = "Permission Denied";
          country = "Permission Denied";
        });
        return;
      }

      if (permission.isGranted) {
        if (!await Geolocator.isLocationServiceEnabled()) {
          setState(() {
            city = "Location Services Disabled";
            country = "Location Services Disabled";
          });
          return;
        }

        // Updated to use AndroidSettings for better compatibility
        currentPosition = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 10),
          ),
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude);
        Placemark place = placemarks[0];
        setState(() {
          city = place.locality ?? 'Unknown';
          country = place.country ?? 'Unknown';
        });

        _calculatePrayerTimes();
      }
    } catch (e) {
      debugPrint('Error getting location: $e'); // Used debugPrint instead of print
      setState(() {
        city = "Error";
        country = "Error";
      });
    }
  }

  void _calculatePrayerTimes() {
    try {
      debugPrint("Calculating prayer times..."); // Used debugPrint
      CalculationParameters params = _getCalculationParameters(widget.selectedMethod);

      final coordinates = Coordinates(currentPosition!.latitude, currentPosition!.longitude);

      final prayerTimesObject = PrayerTimes.today(coordinates, params);

      setState(() {
        prayerTimes = [
          Prayer(name: 'Fajr', time: prayerTimesObject.fajr),
          Prayer(name: 'Dhuhr', time: prayerTimesObject.dhuhr),
          Prayer(name: 'Asr', time: prayerTimesObject.asr),
          Prayer(name: 'Maghrib', time: prayerTimesObject.maghrib),
          Prayer(name: 'Isha', time: prayerTimesObject.isha),
        ];
      });

      for (var prayer in prayerTimes) {
        debugPrint("${prayer.name}: ${prayer.time}"); // Used debugPrint
      }

      debugPrint("Prayer times calculated successfully."); // Used debugPrint
    } catch (e) {
      debugPrint('Error calculating prayer times: $e'); // Used debugPrint
    }
  }

  CalculationParameters _getCalculationParameters(String selectedMethod) {
    debugPrint("Selected calculation method: $selectedMethod"); // Used debugPrint
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

  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
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
      body: Padding(
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
              'Selected Method:',
              style: TextStyle(fontFamily: 'Lato', fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              widget.selectedMethod,
              style: const TextStyle(
                  fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              'Prayer Times for Today:',
              style: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            prayerTimes.isEmpty
                ? const Center(child: CircularProgressIndicator())
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
}

class Prayer {
  final String name;
  final DateTime time;

  Prayer({required this.name, required this.time});
}
