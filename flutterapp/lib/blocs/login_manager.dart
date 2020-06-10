import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutterapp/services/authentication.dart';

class LogInManager {/*
  LogInManager({@required this.model});
  final ValueNotifier<LogInModel> model;

  Future<UserModel> _signIn(Future<UserModel> Function() signInMethod) async {
    try {
      updateWith(isLoading: true);
      return await signInMethod();
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }/*

  Future<UserModel> signInGoogle() async =>
      await _signIn(authenticationBase.signInWithGoogle);*/

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = model.value.formType == LogInPageFormType.logIn
        ? LogInPageFormType.register
        : LogInPageFormType.logIn;
    updateWith(
        email: '',
        password: '',
        formType: formType,
        submitted: false,
        isLoading: false);
  }

  void updateWith(
      {String email,
      String password,
      LogInPageFormType formType,
      bool isLoading,
      bool submitted}) {
    model.value = model.value.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted);
  }

  Future<void> signWithEmailAndPassword() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (model.value.formType == LogInPageFormType.logIn) {
        await authenticationBase.signInWithEmailAndPassword(
            model.value.email, model.value.password);
      } else {
        await authenticationBase.createUserWithEmailAndPassword(
            model.value.email, model.value.password);
      }
    } catch (e) {
      updateWith(submitted: true, isLoading: true);
      rethrow;
    }
  }*/
}
