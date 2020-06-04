import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/view_models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthenticationBase {
  Stream<UserModel> get onAuthenticationStateChaned;
  Future<UserModel> currentUser();
  Future<UserModel> signInGoogle();
  Future<void> signOut();
}

class AuthenticationFirebase implements AuthenticationBase {
  final _firebaseAuth = FirebaseAuth.instance;
  UserModel _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return UserModel(id: user.uid, name: user.displayName, username: user.email);
  }

  @override
  Stream<UserModel> get onAuthenticationStateChaned {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<UserModel> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<UserModel> signInGoogle() async {
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
        return _userFromFirebase(authenticationResult.user);
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
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
