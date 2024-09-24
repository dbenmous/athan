import 'package:flutter/material.dart';
import 'dart:math';

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

class _StoryDetailPageState extends State<StoryDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Slow down the movement significantly
    _animationController = AnimationController(
      duration: const Duration(seconds: 40), // Extremely slow movement
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation back and forth
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent background for rounded effect
      appBar: AppBar(
        title: const Text('Story Detail'),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Remove default back button
        actions: [
          IconButton(
            icon: const Text(
              'X',
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make the X button bold
                color: Colors.white, // White color for the X
                fontSize: 22, // Slightly bigger font size for better visibility
              ),
            ),
            onPressed: () {
              widget.onClose();
              Navigator.pop(context); // Close story and return to main page
            },
          ),
        ],
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), // Rounded top-left corner (20 radius)
          topRight: Radius.circular(20), // Rounded top-right corner (20 radius)
        ),
        child: Container(
          color: Colors.white, // Set a background color for the content
          child: Column(
            children: [
              const SizedBox(height: 20), // Add some space from the top
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  // Create a subtle floating, tilting, and zooming movement
                  return Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        3 * sin(_animationController.value * 2 * pi),  // Very small left-right movement
                        2 * cos(_animationController.value * 2 * pi),   // Very small up-down movement
                      )
                      ..scale(1 + 0.02 * sin(_animationController.value * 2 * pi)) // Small scale for zoom in/out effect
                      ..rotateZ(0.01 * sin(_animationController.value * 2 * pi)), // Very subtle tilt effect
                    child: child,
                  );
                },
                // Add padding and rounded corners to the image
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20), // Padding on right and left
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16), // Rounded corners for the image
                    child: Image.asset(
                      widget.imagePath,
                      width: double.infinity, // Take full available width
                      height: 200, // Adjust height as needed
                      fit: BoxFit.cover, // Ensure the image is cropped correctly
                    ),
                  ),
                ),
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
        ),
      ),
    );
  }
}
