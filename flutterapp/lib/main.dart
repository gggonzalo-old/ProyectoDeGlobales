import 'package:flutter/material.dart';
import 'package:flutterapp/pages/create_post.dart';
import 'package:flutterapp/pages/landing_page.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/services/graphQL/graphQL_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationBase>(
          create: (BuildContext context) => AuthenticationFirebase(),
        ),
        Provider<DataService>(
          create: (BuildContext context) => GraphQLService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.light(),
        home: LandingPage(),
      ),
    );
  }
}
