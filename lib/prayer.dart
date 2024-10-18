import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For location icon
import 'package:shared_preferences/shared_preferences.dart';
import 'duae.dart'; // Import the duaes list
import 'hadiths.dart'; // Import the hadiths list
import 'story.dart'; // Import the story page
import 'package:intl/intl.dart'; // For date formatting
import 'settings.dart';
import 'package:permission_handler/permission_handler.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  int currentPage = 0; // Track the current page of duaes
  List<bool> viewedStories = List.generate(7, (index) => false); // Track viewed state of 7 stories
  String location = 'Your City'; // Default city location
  bool isCoarseLocation = false; // To check if the location is precise or not

  @override
  void initState() {
    super.initState();
    _loadLocation(); // Load location from SharedPreferences
    // Calculate today's duae index based on the current date
    DateTime now = DateTime.now();
    currentPage = now.day % duaes.length; // Ensure the duae index wraps around
  }

  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      location = prefs.getString('city') ?? 'Your City';
      isCoarseLocation = !(prefs.getBool('isLocationPrecise') ?? false);
    });
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted) {
      await openAppSettings(); // Open settings to allow precise location
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data (replace with dynamic data later)
    String timeRemaining = '1h 23m';  // Time remaining for the next prayer (to be updated dynamically)
    String nextPrayerTime = '18:30';  // Next prayer time in 24-hour format
    String nextPrayerName = 'Isha';   // Next prayer name
    String hijriDate = '1 Muharram 1446';
    String gregorianDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

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
            child: SingleChildScrollView( // Make the whole page scrollable
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
                          color: Color(0xFFE5ECED), // White circle background
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.more_horiz, // Three horizontal dots icon
                            color: Colors.black, // Black dots
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

                    const SizedBox(height: 20),  // Padding before stories

                    // Stories Section
                    buildStoriesSection(),

                    const SizedBox(height: 20),  // Padding before city name

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
                        if (isCoarseLocation)
                          TextButton(
                            onPressed: _requestLocationPermission,
                            child: const Text(
                              'Enable location for exact times',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFF0000), // Red color for the button
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),  // Padding below city name

                    // Prayers Widgets (3 per row) with even horizontal alignment
                    Column(
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

                        // Swipeable Duae Section
                        buildSwipeableDuaeSection(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildPrayerWidget(String prayerName, String prayerTime, bool isSoundOn, bool isNextPrayer) {
    return Container(
      width: 110,  // Set a fixed width
      height: 130, // Set a fixed height for all widgets
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isNextPrayer ? const Color(0xCFE5ECED) : const Color(0xB6A0B3DD),  // White for next prayer, light grey for others
        borderRadius: BorderRadius.circular(22.0),  // Rounded corners
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

  // Stories Section
// Stories Section
// Stories Section
  Widget buildStoriesSection() {
    DateTime today = DateTime.now();
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7, // Show the last 7 stories
        itemBuilder: (context, index) {
          DateTime storyDate = today.subtract(Duration(days: index));
          String formattedDate = DateFormat('MMMM d').format(storyDate); // Format the date

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0), // Add padding between stories
            child: GestureDetector(
              onTap: () {
                setState(() {
                  viewedStories[index] = true; // Mark the story as viewed
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryDetailPage(
                      imagePath: 'assets/images/story_${index + 1}.png', // Add your image paths here
                      hadithArabic: hadiths[index % hadiths.length].hadithArabic, // Use dot notation for Hadith class
                      hadithEnglish: hadiths[index % hadiths.length].hadithEnglish, // Use dot notation
                      arabicAudio: hadiths[index % hadiths.length].arabicAudio, // Audio path
                      englishAudio: hadiths[index % hadiths.length].englishAudio, // Audio path
                      onClose: () {
                        setState(() {
                          viewedStories[index] = true; // Mark as viewed on close
                        });
                      },
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  // Circular story image
                  ClipOval(
                    child: Image.asset(
                      'assets/images/story_${index + 1}.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      color: viewedStories[index] ? Colors.grey : null, // Dim if viewed
                      colorBlendMode: viewedStories[index] ? BlendMode.saturation : null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formattedDate, // Display the date
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Swipeable Duae Section
  Widget buildSwipeableDuaeSection() {
    return Column(
      children: [
        Container(
          width: 360,  // Set a fixed width to match the prayer widget rows (adjust if needed)
          decoration: BoxDecoration(
            color: const Color(0xB6A0B3DD),  // Transparent grey background
            borderRadius: BorderRadius.circular(15.0),  // Rounded corners
          ),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
            children: [
              SizedBox(
                height: 170, // Automatically adjusts the height based on content
                child: PageView.builder(
                  controller: PageController(initialPage: currentPage), // Start with the duae of the day
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemCount: duaes.length,  // Number of duaes
                  itemBuilder: (context, index) {
                    return Center(
                      child: buildDuaeSection(duaes[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Dot indicators to show current duae
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: currentPage % 3 == index ? 10 : 7, // Show only 3 dots for page navigation
                    decoration: BoxDecoration(
                      color: currentPage % 3 == index ? Colors.blueGrey : Colors.grey,  // White-grey color
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget for the "Today's Duae" section (Single widget with duae content)
  Widget buildDuaeSection(String duae) {
    return Container(
      padding: const EdgeInsets.all(12.0), // Add some padding to make it look better
      decoration: BoxDecoration(
        color: const Color(0x00fdfdfd), // Transparent grey background
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align title to the start
        children: [
          // Title: "Today's Duae"
          const Text(
            "Today's Duae",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE5ECED),  // Grey color for the title
            ),
          ),
          const SizedBox(height: 10), // Space between title and duae text

          // Duae content
          // Duae content
          Expanded(  // Use Expanded only if this is inside a Column/Row
            child: SingleChildScrollView(
              child: Text(
                duae,
                style: const TextStyle(
                  fontFamily: 'Jamil-nory',
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFFE5ECED),  // White color for the duae
                ),
                textAlign: TextAlign.center,  // Center the duae text
                //textDirection: TextDirection.rtl,  // Ensure proper right alignment for Arabic
              ),
            ),
          ),
        ],
      ),
    );
  }
}
