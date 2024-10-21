import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'duae.dart';

// Function to build prayer widgets
Widget buildPrayerWidget(String prayerName, String prayerTime, bool isSoundOn, bool isNextPrayer) {
  return Container(
    width: 110, // Fixed width for each prayer widget
    height: 130, // Fixed height for each prayer widget
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: isNextPrayer ? const Color(0xCFE5ECED) : const Color(0xB6A0B3DD),
      borderRadius: BorderRadius.circular(22.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 0),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Icon(
            isSoundOn ? Icons.notifications : Icons.notifications_off,
            color: isNextPrayer ? Colors.black : Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          prayerName,
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isNextPrayer ? Colors.black : Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          prayerTime,
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 15,
            color: isNextPrayer ? Colors.black : const Color(0xFF808080),
          ),
        ),
      ],
    ),
  );
}

// Function to build the prayer grid
Widget buildPrayerGrid(List<Map<String, dynamic>> prayers) {
  return Column(
    children: [
      // First row of 3 widgets
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildPrayerWidget(prayers[0]['name'], prayers[0]['time'], prayers[0]['isSoundOn'], prayers[0]['isNextPrayer']),
          buildPrayerWidget(prayers[1]['name'], prayers[1]['time'], prayers[1]['isSoundOn'], prayers[1]['isNextPrayer']),
          buildPrayerWidget(prayers[2]['name'], prayers[2]['time'], prayers[2]['isSoundOn'], prayers[2]['isNextPrayer']),
        ],
      ),
      const SizedBox(height: 16), // Space between rows
      // Second row of 3 widgets
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildPrayerWidget(prayers[3]['name'], prayers[3]['time'], prayers[3]['isSoundOn'], prayers[3]['isNextPrayer']),
          buildPrayerWidget(prayers[4]['name'], prayers[4]['time'], prayers[4]['isSoundOn'], prayers[4]['isNextPrayer']),
          buildPrayerWidget(prayers[5]['name'], prayers[5]['time'], prayers[5]['isSoundOn'], prayers[5]['isNextPrayer']),
        ],
      ),
    ],
  );
}

// Function to build the stories section
Widget buildStoriesSection(List<bool> viewedStories, BuildContext context) {
  if (viewedStories.isEmpty) {
    return Container(); // Return an empty container if the list is empty
  }

  DateTime today = DateTime.now();
  return SizedBox(
    height: 100,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: viewedStories.length,
      itemBuilder: (context, index) {
        DateTime storyDate = today.subtract(Duration(days: index));
        String formattedDate = DateFormat('MMMM d').format(storyDate);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: GestureDetector(
            onTap: () {
              // Implement your navigation logic here
            },
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/story_${index + 1}.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    color: viewedStories[index] ? Colors.grey : null,
                    colorBlendMode: viewedStories[index] ? BlendMode.saturation : null,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formattedDate,
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

// Function to build the swipeable duae section
Widget buildSwipeableDuaeSection(int currentPage, Function(int) onPageChanged, List<String> duaes) {
  if (duaes.isEmpty) {
    return Container(); // Return an empty container if the list is empty
  }

  return Column(
    children: [
      Container(
        width: 360,
        decoration: BoxDecoration(
          color: const Color(0xB6A0B3DD),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 170,
              child: PageView.builder(
                controller: PageController(initialPage: currentPage),
                onPageChanged: (index) {
                  onPageChanged(index);
                },
                itemCount: duaes.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: buildDuaeSection(duaes[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 10,
                  width: currentPage % 3 == index ? 10 : 7,
                  decoration: BoxDecoration(
                    color: currentPage % 3 == index ? Colors.blueGrey : Colors.grey,
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

// Widget for the "Today's Duae" section
Widget buildDuaeSection(String duae) {
  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: const Color(0x00fdfdfd),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Duae",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE5ECED),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              duae,
              style: const TextStyle(
                fontFamily: 'Jamil-nory',
                fontSize: 25,
                fontWeight: FontWeight.normal,
                color: Color(0xFFE5ECED),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );
}
