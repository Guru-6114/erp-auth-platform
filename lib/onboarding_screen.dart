// onboarding_screen.dart
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 3) {
      setState(() => _currentPage++);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. Progress Bar
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / 4,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58CC02)),
            ),
          ),
          
          // 2. Animated Content Area
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
              child: _buildPage(_currentPage, key: ValueKey(_currentPage)),
            ),
          ),
          
          // 3. Action Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF58CC02)),
                onPressed: _nextPage,
                child: Text("CONTINUE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index, {required Key key}) {
    // Return different widgets based on the 4 images provided
    return Center(key: key, child: Text("Screen ${index + 1} Content"));
  }
}