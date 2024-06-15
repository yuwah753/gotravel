import 'package:flutter/material.dart';
import 'package:gotravel/pages/login.dart';

// SplashScreen widget to display the splash screen of the app
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

// State for SplashScreen widget
class _SplashScreenState extends State<SplashScreen> {
  // Initialize the state of the widget
  @override
  void initState() {
    super.initState();
    // Navigate to the login screen after a delay
    _navigateToHome();
  }

  // Function to navigate to the login screen after a delay
  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2)); // Delay for 2 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(), // Navigate to the LoginPage
      ),
    );
  }

  // Build the UI of the SplashScreen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Set background color to blue
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
        children: [
          Spacer(flex: 3), // Add flexible space at the top
          // Display the logo image
          Center(
            child: Image.asset(
              'images/logo.png', // Path to the logo image
              width: 150, // Image width
              height: 150, // Image height
            ),
          ),
          Spacer(flex: 3), // Add flexible space at the bottom
          // Display the app name at the bottom center
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                'Go Travel', // App name
                style: TextStyle(
                  fontFamily: 'ABeeZee', // Font family
                  fontSize: 24, // Font size
                  fontWeight: FontWeight.bold, // Font weight
                  color: Colors.white, // Text color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
