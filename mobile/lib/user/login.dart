import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/user/register.dart';
import 'dart:convert';
import 'package:mobile/games/games.dart';
import 'package:mobile/settings.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String loggedInUsername = "";

  void login() async {
    const String scheme = Settings.scheme;
    const String ip = Settings.ip;
    const int port = Settings.port;

    const url = '$scheme://$ip:$port/api/login';

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
        loggedInUsername = _usernameController.text;
        //  print(loggedInUsername);
        navigateToGames();
      } else {
        // todo: when register is failed do something here
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void navigateToGames() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamesPage(loggedInUsername: loggedInUsername),
      ),
    );
  }

  void navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Color.fromRGBO(0, 154, 58, 1),
      ),
      body: Container(
        color: Color.fromRGBO(0, 154, 58, 1),
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
                onPressed: login,
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Not registered?',
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: navigateToRegister,
                    child: const Text(
                      ' Register',
                      style: TextStyle(color: Colors.amber),
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
