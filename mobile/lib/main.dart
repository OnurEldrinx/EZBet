import 'package:flutter/material.dart';
import 'user/login.dart';
//import 'user/register.dart';
import 'games/games.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GamesPage(),
    );
  }
}
