import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/data.dart';

enum SearchType { users, posts }

class SearchModel with ChangeNotifier {
  SearchModel(
      {@required this.dataService,
      this.users = const [],
      this.posts = const [],
      this.isLoading = false,
      this.search = '',
      this.searchType = SearchType.posts});

  final DataService dataService;
  List<User> users;
  List<Post> posts;
  bool isLoading;
  String search;
  SearchType searchType;

  Future<void> updateUsers() async {
    try {
      updateWith(isLoading: true);
      if (searchType == SearchType.posts) {
        updateWith(users: await dataService.getUsers());
      } else {
        updateWith(users: await dataService.getUsers());
      }
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void toggleSearchType(SearchType searchType) {
    updateWith(
        users: const [],
        posts: const [],
        searchType: searchType,
        isLoading: false);
  }

  void updateSearch(String search) async {
    updateWith(search: search);
    await updateUsers();
  }

  void updateWith(
      {List<User> users,
      List<Post> posts,
      bool isLoading,
      String search,
      SearchType searchType}) {
    this.users = users ?? this.users;
    this.posts = posts ?? this.posts;
    this.isLoading = isLoading ?? this.isLoading;
    this.search = search ?? this.search;
    this.searchType = searchType ?? this.searchType;
    notifyListeners();
  }
}
