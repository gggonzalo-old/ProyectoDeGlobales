import 'package:flutter/material.dart';
import 'package:flutterapp/pages/bottom_navigation.dart';
import 'package:flutterapp/pages/login.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/view_models/user_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authentication =
        Provider.of<AuthenticationBase>(context, listen: false);

    return StreamBuilder(
      stream: authentication.onAuthenticationStateChaned,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserModel user = snapshot.data;
          if (user == null) {
            return LoginPage.create(context);
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
