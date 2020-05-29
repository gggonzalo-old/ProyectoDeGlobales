import 'package:flutter/material.dart';
import 'package:flutterapp/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: LoginPage(title: 'Flutter Demo Home Page'),
    );
  }
}