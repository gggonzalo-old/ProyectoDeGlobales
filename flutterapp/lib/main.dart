import 'package:flutter/material.dart';
import 'package:flutterapp/blocs/user_bloc.dart';
import 'package:flutterapp/pages/home.dart';
import 'package:flutterapp/pages/landing_page.dart';
import 'package:flutterapp/pages/profile.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
        theme: ThemeData.dark(),
        home: LandingPage(),
      ),
    );
  }
}
