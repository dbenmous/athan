import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'prayer_time_utils.dart'; // Import the utility functions
import 'calculation.dart'; // For navigating to the debug calculation page.

class PrayerTimesPage extends StatefulWidget {
  @override
  _PrayerTimesPageState createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  String currentMethod = 'Umm al-Qura University, Makkah';
  bool isAutomatic = false;
  List<String> calculationMethods = [
    'Muslim World League',
    'Egyptian General Authority of Survey',
    'University of Islamic Sciences, Karachi',
    'Umm al-Qura University, Makkah',
    'Dubai',
    'Moonsighting Committee',
    'North America (ISNA)',
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences(); // Load the saved method or automatic setting
  }

  // Load saved method and settings from SharedPreferences
  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentMethod = prefs.getString('selectedMethod') ?? 'Umm al-Qura University, Makkah';
      isAutomatic = prefs.getBool('isAutomatic') ?? false;
    });
  }

  // Save the selected method or settings to SharedPreferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedMethod', currentMethod);
    await prefs.setBool('isAutomatic', isAutomatic);
    // After saving preferences, update the prayer times immediately
    await updatePrayerTimesIfNeeded(); // Call the utility method to update prayer times
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation Methods', style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Method Section
            const Text(
              'CURRENT METHOD',
              style: TextStyle(fontFamily: 'Lato', fontSize: 17, color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                currentMethod,
                style: const TextStyle(fontFamily: 'Lato', fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Automatic Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Automatic',
                  style: TextStyle(fontFamily: 'Lato', fontSize: 17),
                ),
                Switch(
                  value: isAutomatic,
                  onChanged: (value) async {
                    setState(() {
                      isAutomatic = value;
                    });
                    await _savePreferences(); // Save the setting whenever it is toggled and update times
                  },
                ),
              ],
            ),

            // Calculation Methods List (Hidden if Automatic is enabled)
            if (!isAutomatic) ...[
              const SizedBox(height: 20),
              const Text(
                'CALCULATION METHODS',
                style: TextStyle(fontFamily: 'Lato', fontSize: 17, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: calculationMethods.map((method) {
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        currentMethod = method;
                      });
                      await _savePreferences(); // Save the selected method and update times
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        method,
                        style: const TextStyle(fontFamily: 'Lato', fontSize: 17),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 20),

            // Button to navigate to Calculation Page (Debugging or to show saved times)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalculationPage(), // Navigate to the calculation page
                  ),
                );
              },
              child: const Text('Go to Calculation Page'),
            ),
          ],
        ),
      ),
    );
  }
}
