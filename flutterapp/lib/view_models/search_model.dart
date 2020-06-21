import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

enum SearchType { users, posts }

class SearchModel with ChangeNotifier {
  SearchModel(
      {@required this.dataService,
      @required this.authentication,
      this.users = const [],
      this.posts = const [],
      this.event,
      this.isLoading = false,
      this.search = "",
      this.searchType = SearchType.posts});

  TextEditingController searchController = TextEditingController();
  final DataService dataService;
  final AuthenticationBase authentication;
  List<User> users;
  List<Post> posts;
  Event event;
  bool isLoading;
  String search;
  SearchType searchType;

  Future<void> updateData() async {
    try {
      updateWith(isLoading: true);
      User user = await authentication.currentUser();
      if (searchType == SearchType.posts) {
        List<Post> posts = await dataService.getPostsByHashTag(search);
        Event event = Event();
        if (posts.isNotEmpty) {
          event.id = search;
          event = await dataService.getEvent(user, event);
        }
        updateWith(posts: posts, event: event);
      } else {
        updateWith(users: await dataService.getUsers(user, search));
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
    await updateData();
  }

  void addFriend(User friend) async {
    try {
      updateWith(isLoading: true);
      User user = await authentication.currentUser();
      await dataService.addFriend(user, friend);
      await updateData();
    } catch (e) {
      rethrow;
    }
  }

  void updateWith(
      {List<User> users,
      List<Post> posts,
      Event event,
      bool isLoading,
      String search,
      SearchType searchType}) {
    this.users = users ?? this.users;
    this.posts = posts ?? this.posts;
    this.event = event ?? this.event;
    this.isLoading = isLoading ?? this.isLoading;
    this.search = search ?? this.search;
    this.searchType = searchType ?? this.searchType;
    notifyListeners();
  }
}
