import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/student_provider.dart';
import 'screens/landing_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StudentProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const HomePage(
              token: '',
            ),
      },
    );
  }
}
