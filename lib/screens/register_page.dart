import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateinput = TextEditingController();

  @override
  void initState() {
    _dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  Future<void> _register() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': _firstnameController.text,
          'last_name': _lastnameController.text,
          'tanggal_lahir': _dateinput.text,
          'no_telp': _phonenumberController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'role': 1,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        final errorData = response.body;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Failed'),
            content: Text('Failed to register user. Error: $errorData'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $error'),
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
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.black, // Customize the text color
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, // Change the color of the arrow to black
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32.0),
              TextFormField(
                controller: _firstnameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(
                    Icons.person,
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
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _lastnameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(
                    Icons.person,
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
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _dateinput,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.grey[600], // Customize the prefix icon color
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      _dateinput.text = formattedDate;
                    });
                  } else {
                    print('Date is not selected');
                  }
                },
                style: const TextStyle(
                  color: Colors.black, // Customize the text color
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phonenumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(
                    Icons.phone,
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
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
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
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _register();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  primary: Colors.blue, // Customize the button color
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Customize the text color
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
