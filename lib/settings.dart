import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'prayer_times.dart'; // Import the target page for calculation

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black), // Customizable back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.calculate,
            title: 'Calculation',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrayerTimesPage()),
              );
            },
          ),
          _buildDivider(),
          _buildSettingsItem(
            context,
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              // Handle Notifications click
            },
          ),
          _buildDivider(),
          _buildSettingsItem(
            context,
            icon: Icons.location_on,
            title: 'Location',
            onTap: () {
              // Handle Location click
            },
          ),
          _buildDivider(),
          _buildSettingsItem(
            context,
            icon: Icons.apps,
            title: 'App Icon',
            onTap: () {
              // Handle App Icon click
            },
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  // Method to build each settings item
  Widget _buildSettingsItem(BuildContext context,
      {required IconData icon, required String title, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white, // Background in white hex
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueGrey),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Method to build divider between items
  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
      height: 1,
    );
  }
}
