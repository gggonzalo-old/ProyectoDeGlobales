import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/data.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthenticationBase {
  Stream<User> get onAuthenticationStateChanged;
  Future<User> currentUser();
  Future<User> signInWithGoogle();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class AuthenticationFirebase implements AuthenticationBase {
  final _firebaseAuth = FirebaseAuth.instance;
  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }

    List<String> splitEmail = user.email.split('@');

    return User(
      id: user.uid,
      name: user.displayName,
      username: splitEmail[0],
      photoUrl: user.photoUrl,
    );
  }

  @override
  Stream<User> get onAuthenticationStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      if (googleSignInAuthentication.accessToken != null &&
          googleSignInAuthentication.idToken != null) {
        final authenticationResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken,
          ),
        );

        User user = _userFromFirebase(authenticationResult.user);

        if (authenticationResult.additionalUserInfo.isNewUser) {
          GraphQLService graphQLService = GraphQLService();

          await graphQLService.createUser(user);
        }

        return user;
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authenticationResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authenticationResult.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authenticationResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authenticationResult.user);
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
