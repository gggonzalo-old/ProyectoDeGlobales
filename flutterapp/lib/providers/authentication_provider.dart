
import 'package:flutter/material.dart';
import 'package:flutterapp/services/authentication.dart';

class AuthenticationProvider extends InheritedWidget {
  AuthenticationProvider({@required this.authentication, @required this.child});

  final AuthenticationBase authentication;
  final Widget child;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static AuthenticationBase of(BuildContext context){
    AuthenticationProvider provider = context.dependOnInheritedWidgetOfExactType<AuthenticationProvider>();
    return provider.authentication;
  }

}