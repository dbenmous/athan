import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For location icon

class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data (replace with dynamic data later)
    String timeRemaining = '1h 23m';  // Time remaining for the next prayer (to be updated dynamically)
    String nextPrayerTime = '06:30 PM';  // Next prayer time
    String nextPrayerName = 'Isha';      // Next prayer name
    String hijriDate = '1 Muharram 1446';
    String gregorianDate = 'September 19, 2024';
    String location = 'Your City';       // City location

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
                          fontSize: 24,
                          color: Color(0xFFE5ECED), // Grey color (#808080)
                        ),
                      ),
                      Text(
                        timeRemaining,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 24,
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
                          fontSize: 38,
                          color: Color(0xFFFFFFFF), // Light grey (#D3D3D3)
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        nextPrayerTime,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 38,
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

                  const SizedBox(height: 20),

                  // Location Section with location icon and city name aligned to the left
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.locationArrow,  // Location icon
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
