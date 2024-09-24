import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';  // For playing audio

class StoryDetailPage extends StatefulWidget {
  final String imagePath;
  final String hadithArabic;
  final String hadithEnglish;
  final String arabicAudio;
  final String englishAudio;
  final VoidCallback onClose;

  const StoryDetailPage({
    required this.imagePath,
    required this.hadithArabic,
    required this.hadithEnglish,
    required this.arabicAudio,
    required this.englishAudio,
    required this.onClose,
    super.key,
  });

  @override
  _StoryDetailPageState createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Slow movement
    _animationController = AnimationController(
      duration: const Duration(seconds: 60), // Slow animation
      vsync: this,
    )..repeat(reverse: true);  // Repeat the animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();  // Dispose of audio player when the widget is destroyed
    super.dispose();
  }

  Future<void> _playAudio(String audioPath) async {
    await _audioPlayer.play(audioPath, isLocal: true);  // Play audio
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
          height: MediaQuery.of(context).size.height,  // Ensure the page covers the full screen height
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Add some space from the top
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    // Floating image with tilt effect
                    return Transform(
                      transform: Matrix4.identity()
                        ..translate(
                          1.5 * sin(_animationController.value * 2 * pi),
                          1 * cos(_animationController.value * 2 * pi),
                        )
                        ..scale(1 + 0.005 * sin(_animationController.value * 2 * pi))
                        ..rotateZ(0.005 * sin(_animationController.value * 2 * pi)),
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20), // Padding on right and left
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Rounded corners for the image
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
                // Display the hadith in Arabic with audio
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.hadithArabic,
                        style: const TextStyle(
                          fontFamily: 'Amiri',  // Arabic font
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.right,  // Right-aligned for Arabic
                        textDirection: TextDirection.rtl,  // RTL for Arabic
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, size: 30, color: Colors.black),
                        onPressed: () {
                          _playAudio(widget.arabicAudio);  // Play Arabic audio
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Display the hadith in English with audio
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.hadithEnglish,
                        style: const TextStyle(
                          fontFamily: 'Mulish',  // English font
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,  // Left-aligned for English
                        textDirection: TextDirection.ltr,  // LTR for English
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, size: 30, color: Colors.black),
                        onPressed: () {
                          _playAudio(widget.englishAudio);  // Play English audio
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
