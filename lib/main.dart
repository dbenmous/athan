import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'prayer.dart'; // Import the prayer page

void main() {
  runApp(Athan());
}

class Athan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // Default tab is the first (Prayer tab)

  // List of pages for the bottom navigation bar tabs
  final List<Widget> _pages = [
    const PrayerPage(),  // Prayer page as the first tab
    const QiblaPage(),
    const CalendarPage(),
    const MosquesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body will show the content of the selected tab
      body: _pages[_currentIndex],

      // Bottom navigation bar
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
            icon: FaIcon(FontAwesomeIcons.personPraying), // Praying man icon
            label: 'Prayer',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.kaaba), // Kaaba icon
            label: 'Qibla',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.calendarAlt), // Calendar icon
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.mosque), // Mosque icon
            label: 'Mosques',
          ),
        ],
      ),
    );
  }
}

// Placeholder for Qibla Page
class QiblaPage extends StatelessWidget {
  const QiblaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Qibla Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}

// Placeholder for Calendar Page
class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Calendar Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}

// Placeholder for Mosques Page
class MosquesPage extends StatelessWidget {
  const MosquesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Mosques Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}
