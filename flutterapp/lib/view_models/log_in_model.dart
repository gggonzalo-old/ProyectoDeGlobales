import 'package:flutter/widgets.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/utils/validators.dart';

enum LogInPageFormType { logIn, register }

class LogInModel with EmailAndPasswordValidators, ChangeNotifier {
  LogInModel({
    @required this.authenticationBase,
    this.email = '',
    this.password = '',
    this.formType = LogInPageFormType.logIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final AuthenticationBase authenticationBase;
  String email;
  String password;
  LogInPageFormType formType;
  bool isLoading;
  bool submitted;

  void updateWith(
      {String email,
      String password,
      LogInPageFormType formType,
      bool isLoading,
      bool submitted}) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      updateWith(isLoading: true);
      return await signInMethod();
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  Future<User> signInGoogle() async =>
      await _signIn(authenticationBase.signInWithGoogle);

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  String get primaryButtonText {
    return formType == LogInPageFormType.logIn ? 'Log In' : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == LogInPageFormType.logIn ? 'Log In' : 'Create an account';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  void toggleFormType() {
    final formType = this.formType == LogInPageFormType.logIn
        ? LogInPageFormType.register
        : LogInPageFormType.logIn;
    updateWith(
        email: '',
        password: '',
        formType: formType,
        submitted: false,
        isLoading: false);
  }

  Future<void> signWithEmailAndPassword() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == LogInPageFormType.logIn) {
        await authenticationBase.signInWithEmailAndPassword(email, password);
      } else {
        await authenticationBase.createUserWithEmailAndPassword(
            email, password);
      }
    } catch (e) {
      updateWith(submitted: true, isLoading: true);
      rethrow;
    }
  }
}
