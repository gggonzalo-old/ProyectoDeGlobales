import 'package:flutter/material.dart';
import 'package:flutterapp/pages/bottom_navigation.dart';
import 'package:flutterapp/pages/login.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/models/user.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authentication =
        Provider.of<AuthenticationBase>(context);

    return StreamBuilder<User>(
      stream: authentication.onAuthenticationStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return LogInPage.create(context);
          }
          return BottomNavigation();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
