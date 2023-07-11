import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['authorization']['token'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: token)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid email or password.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, // Set the arrow color to black
        ),
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.black, // Customize the text color
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey[600], // Customize the prefix icon color
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black, // Customize the text color
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey[600], // Customize the prefix icon color
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
                style: const TextStyle(
                  color: Colors.black, // Customize the text color
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  primary: Colors.blue, // Customize the button color
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Customize the text color
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0.0),
                ),
                child: const Text(
                  'New User? Click Here',
                  style: TextStyle(
                    color: Colors.blue, // Customize the text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
