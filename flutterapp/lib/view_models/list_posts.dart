import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/data.dart';

class PostsListModel with ChangeNotifier {
  PostsListModel(
      {@required this.dataService,
      this.users = const [],
      this.isLoading = false,
      this.username = ''});

  final DataService dataService;
  List<User> users;
  bool isLoading;
  String username;

  Future<void> updateUsers() async {
    try {
      updateWith(isLoading: true);
      updateWith(users: await dataService.getUsers());
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateSearchUsername(String username) async {
    updateWith(username: username);
    await updateUsers();
  }

  void updateWith({List<User> users, bool isLoading, String username}) {
    this.users = users ?? this.users;
    this.isLoading = isLoading ?? this.isLoading;
    this.username = username ?? this.username;
    notifyListeners();
  }
}
