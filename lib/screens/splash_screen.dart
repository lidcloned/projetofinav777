import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for checking login status
import 'home_screen.dart'; // Import HomeScreen
import 'login_screen.dart'; // Import LoginScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Use separate players for potentially overlapping sounds
  final AudioPlayer _playerTiro = AudioPlayer();
  final AudioPlayer _playerSombrio = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of fade-in
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start animation
    _animationController.forward();

    // Play sounds - Using paths from NOVOMETADADOS.txt
    // NOTE: Ensure 'tiro_start.mp3' and 'som_sombrio.mp3' exist in 'assets/audio/'
    _playSound("audio/tiro_start.mp3", _playerTiro, loop: false);
    _playSound("audio/som_sombrio.mp3", _playerSombrio, loop: true);

    // Navigate after delay
    _navigateToNextScreen();
  }

  Future<void> _playSound(String path, AudioPlayer player, {bool loop = false}) async {
    try {
      await player.setSource(AssetSource(path));
      if (loop) {
        player.setReleaseMode(ReleaseMode.loop);
      }
      await player.resume(); // Use resume() instead of play() for consistency
      print('Sound played: $path');
    } catch (e) {
      print('Error playing sound $path: $e');
      // Handle error silently or show a message if critical
    }
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for splash duration
    await Future.delayed(const Duration(seconds: 5));

    // Stop looping sound before navigating
    await _playerSombrio.stop();

    // Check login status before navigating
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('loggedIn') ?? false;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? const HomeScreen() : const LoginScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _playerTiro.dispose();
    _playerSombrio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Explicit black background
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated Logo
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                // NOTE: Ensure 'logo_lamafia.png' exists in 'assets/images_png/'
                'assets/images_png/logo_lamafia.png', // Use a specific logo name if available
                width: 200, // Adjust size as needed
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                   print('Error loading logo_lamafia.png: $error');
                   // Fallback icon if logo fails
                   return const Icon(Icons.shield_moon, size: 150, color: Colors.purpleAccent);
                },
              ),
            ),
          ),
          // Loading Text at the bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'LAMAFIA INICIANDO...',
                style: TextStyle(
                  fontFamily: 'Digital', // Ensure 'Digital' font is declared in pubspec
                  color: Colors.white70,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

