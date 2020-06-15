import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

class ProfileModel with ChangeNotifier {
  ProfileModel({
    @required this.authentication,
    @required this.dataService,
    this.user,
    this.isLoading = true,
  });

  final AuthenticationBase authentication;
  final DataService dataService;
  User user;
  bool isLoading;

  Future<void> updateData() async {
    try {
      updateWith(isLoading: true);
      User currentUser = await authentication.currentUser();
      User user = await dataService.getUser(currentUser);
      updateWith(user: user);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateWith({
    User user,
    bool isLoading,
  }) {
    this.user = user ?? this.user;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }
}
