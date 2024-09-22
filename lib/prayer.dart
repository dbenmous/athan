import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For location icon

class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data (replace with dynamic data later)
    String timeRemaining = '1h 23m';  // Time remaining for the next prayer (to be updated dynamically)
    String nextPrayerTime = '18:30';  // Next prayer time in 24-hour format
    String nextPrayerName = 'Isha';      // Next prayer name
    String hijriDate = '1 Muharram 1446';
    String gregorianDate = 'September 19, 2024';
    String location = 'Your City';       // City location
    String todaysDua = 'اللهم اجعلني من التوابين واجعلني من المتطهرين  '; // Long Dua example

    Map<String, String> prayers = {
      'Fajr': '05:00',
      'Sunrise': '06:00',
      'Dhuhr': '13:00',
      'Asr': '16:30',
      'Maghrib': '19:15',
      'Isha': '20:30',
    };

    Map<String, bool> soundStatus = {
      'Fajr': true,
      'Sunrise': false,
      'Dhuhr': false,
      'Asr': true,
      'Maghrib': false,
      'Isha': true,
    };

    String nextPrayer = 'Asr';  // Next prayer to be highlighted

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/prayer_background.png"),
                fit: BoxFit.cover,  // Ensures the image covers the entire screen
              ),
            ),
          ),
          // SafeArea to prevent overlap with system UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Settings icon as three horizontal dots inside a white circle
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // White circle background
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.more_horiz, // Three horizontal dots icon
                          color: Colors.black, // Black dots
                        ),
                        onPressed: () {
                          // Add your settings page navigation here
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Next Prayer Section: "Next prayer in" followed by the time remaining (same line)
                  Row(
                    children: [
                      const Text(
                        'Next Prayer in ',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 20,
                          color: Color(0xFFE5ECED), // Grey color (#808080)
                        ),
                      ),
                      Text(
                        timeRemaining,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 20,
                          color: Color(0xFFFFFFFF), // Same grey color for consistency
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Next prayer name (Isha) and time on the same line (new line)
                  Row(
                    children: [
                      Text(
                        nextPrayerName,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 48,
                          fontWeight: FontWeight.bold, // Set font weight to bold
                          color: Color(0xFFFFFFFF), // Light grey (#D3D3D3)
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        nextPrayerTime,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 48,
                          fontWeight: FontWeight.bold, // Set font weight to bold
                          color: Color(0xFFE6E6E6), // Lighter grey (#E6E6E6)
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Date Section (Hijri and Gregorian dates)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        hijriDate,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          color: Color(0xFFB0C4DE), // LightSteelBlue (#B0C4DE)
                        ),
                      ),
                      Text(
                        gregorianDate,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          color: Color(0xFFB0C4DE), // LightSteelBlue (#B0C4DE)
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),  // Padding below city name

                  // City name and location icon
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.locationDot,  // Location icon
                        size: 25,
                        color: Color(0xFFB0C4DE),
                      ),
                      const SizedBox(width: 10),  // Space between icon and text
                      Text(
                        location,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 35,
                          color: Color(0xFFFFFFFF), // White/Grey (#F8F8FF)
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),  // Padding below city name

                  // Prayers Widgets (3 per row) with even horizontal alignment
                  Expanded(
                    child: Column(
                      children: [
                        // First row of 3 widgets
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // Equal space between widgets
                          children: [
                            buildPrayerWidget('Fajr', prayers['Fajr']!, soundStatus['Fajr']!, nextPrayer == 'Fajr'),
                            buildPrayerWidget('Sunrise', prayers['Sunrise']!, soundStatus['Sunrise']!, nextPrayer == 'Sunrise'),
                            buildPrayerWidget('Dhuhr', prayers['Dhuhr']!, soundStatus['Dhuhr']!, nextPrayer == 'Dhuhr'),
                          ],
                        ),
                        const SizedBox(height: 16),  // Space between rows
                        // Second row of 3 widgets
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // Equal space between widgets
                          children: [
                            buildPrayerWidget('Asr', prayers['Asr']!, soundStatus['Asr']!, nextPrayer == 'Asr'),
                            buildPrayerWidget('Maghrib', prayers['Maghrib']!, soundStatus['Maghrib']!, nextPrayer == 'Maghrib'),
                            buildPrayerWidget('Isha', prayers['Isha']!, soundStatus['Isha']!, nextPrayer == 'Isha'),
                          ],
                        ),
                        const SizedBox(height: 30),  // Space above Today's Duae

                        // Scrollable Today's Duae section (Single widget with title and duae)
                        Expanded(
                          child: SingleChildScrollView(
                            child: buildDuaeSection("Today's Duae", todaysDua),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each prayer widget
  Widget buildPrayerWidget(String prayerName, String prayerTime, bool isSoundOn, bool isNextPrayer) {
    return Container(
      width: 110,  // Set a fixed width
      height: 130, // Set a fixed height for all widgets
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isNextPrayer ? const Color(0xCFE5ECED) : const Color(0xB6A0B3DD),  // White for next prayer, light grey for others
        borderRadius: BorderRadius.circular(19.0),  // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 0),  // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bell icon (filled or outlined)
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              isSoundOn ? Icons.notifications : Icons.notifications_off,  // Bell icon
              color: isNextPrayer ? Colors.black : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          // Prayer name
          Text(
            prayerName,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isNextPrayer ? Colors.black : Colors.white,  // Black for next prayer, white for others
            ),
          ),
          const SizedBox(height: 5),
          // Prayer time in 24-hour format
          Text(
            prayerTime,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 15,
              color: isNextPrayer ? Colors.black : const Color(0xFF808080),  // Grey for others, black for next prayer
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the "Today's Duae" section (Single widget with title and duae)
  Widget buildDuaeSection(String title, String duae) {
    return Container(
      width: 355,  // Width of the entire box
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xB6A0B3DD),  // Transparent grey background
        borderRadius: BorderRadius.circular(15.0),  // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE5ECED),  // Grey color for the title
            ),
          ),
          const SizedBox(height: 10),
          // Duae
          Text(
            duae,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Color(0xFFE5ECED),  // White color for the duae
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
