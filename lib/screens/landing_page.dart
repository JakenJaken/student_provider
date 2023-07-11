import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  // Logo Widget
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  const Text(
                    'Welcome to Ticketify',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Find and book tickets for your favorite events!',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  primary: Colors.blue, // Customize the button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Customize the text color
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  primary: Colors.orange, // Customize the button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Customize the text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
