import 'package:flutter/material.dart';
import 'package:flutterapp/blocs/user_bloc.dart';
import 'package:flutterapp/pages/home.dart';
import 'package:flutterapp/pages/login.dart';
import 'package:flutterapp/pages/profile.dart';
import 'package:flutterapp/providers/users_provider.dart';
import 'package:flutterapp/ui/user_widget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: LoginPage(),
    );
  }
}
