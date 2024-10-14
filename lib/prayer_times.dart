import 'package:flutter/material.dart';
import 'calculation.dart'; // Import the calculation page

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
    'North America (ISNA)'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation Methods', style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Method Section
            Text(
              'CURRENT METHOD',
              style: TextStyle(fontFamily: 'Lato', fontSize: 17, color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                currentMethod,
                style: TextStyle(fontFamily: 'Lato', fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            // Automatic Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Automatic',
                  style: TextStyle(fontFamily: 'Lato', fontSize: 17),
                ),
                Switch(
                  value: isAutomatic,
                  onChanged: (value) {
                    setState(() {
                      isAutomatic = value;
                    });
                  },
                ),
              ],
            ),

            // Calculation Methods List (Hidden if Automatic is enabled)
            if (!isAutomatic) ...[
              SizedBox(height: 20),
              Text(
                'CALCULATION METHODS',
                style: TextStyle(fontFamily: 'Lato', fontSize: 17, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                children: calculationMethods.map((method) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentMethod = method;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        method,
                        style: TextStyle(fontFamily: 'Lato', fontSize: 17),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            SizedBox(height: 20),

            // Temporary button for debugging, leading to calculation page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculationPage(selectedMethod: currentMethod)),
                );
              },
              child: Text('Go to Calculation Page'),
            ),
          ],
        ),
      ),
    );
  }
}
