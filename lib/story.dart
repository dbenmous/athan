import 'package:flutter/material.dart';

class StoryDetailPage extends StatefulWidget {
  final String imagePath;
  final String hadith;
  final VoidCallback onClose;

  const StoryDetailPage({
    required this.imagePath,
    required this.hadith,
    required this.onClose,
    super.key,
  });

  @override
  _StoryDetailPageState createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Detail'),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Remove default back button
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.onClose();
              Navigator.pop(context); // Close story and return to main page
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display the full rectangular image
          Image.asset(
            widget.imagePath,
            width: double.infinity,  // Full width of the screen
            height: 300,  // Adjust height as needed
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          // Display the hadith below the image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.hadith,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Mulish',
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
