import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

class ProfileModel with ChangeNotifier {
  ProfileModel(
      {@required this.authentication,
      @required this.dataService,
      this.user,
      this.isLoading = true});

  final AuthenticationBase authentication;
  final DataService dataService;
  User user;
  bool isLoading;
  bool isCurrentUser;
  bool addRemoveFriend = false;

  Future<void> updateData() async {
    try {
      updateWith(isLoading: true);
      User user;
      User currentUser = await authentication.currentUser();
      bool isCurrentUser;
      if ((this.user != null &&
          this.isCurrentUser == null) ||
          addRemoveFriend == true) {
        isCurrentUser = false;
        user = await dataService.getUser(currentUser, this.user);
      } else {
        isCurrentUser = true;
        user = await dataService.getUser(currentUser, currentUser);
      }
      updateWith(user: user, isCurrentUser: isCurrentUser);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void addFriend() async {
    try {
      updateWith(isLoading: true, addRemoveFriend: true);
      User user = await authentication.currentUser();
      await dataService.addFriend(user, this.user);
      await updateData();
    } catch (e) {
      rethrow;
    }
  }

  void removeFriend() async {
    try {
      updateWith(isLoading: true, addRemoveFriend: true);
      User user = await authentication.currentUser();
      await dataService.removeFriend(user, this.user);
      await updateData();
    } catch (e) {
      rethrow;
    }
  }

  void updateWith({
    User user,
    bool isLoading,
    bool isCurrentUser,
    bool addRemoveFriend,
  }) {
    this.user = user ?? this.user;
    this.isLoading = isLoading ?? this.isLoading;
    this.isCurrentUser = isCurrentUser ?? this.isCurrentUser;
    this.addRemoveFriend = addRemoveFriend ?? this.addRemoveFriend;

    notifyListeners();
  }
}
