import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/user/login.dart';
import 'dart:convert';
import 'package:mobile/settings.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void register() async {
    const String scheme = Settings.scheme;
    const String ip = Settings.ip;
    const int port = Settings.port;

    const url = '$scheme://$ip:$port/api/register';

    final Map<String, String> data = {
      'username': _usernameController.text,
      'password': _passwordController.text,
    };

    final Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        navigateToLogin();
      } else {
        // todo: when register is failed do something here
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'Enter your username',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: register,
                child: const Text('Register'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Already registered?',
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: const Text(
                      ' Sign in',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
