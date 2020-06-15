import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/homeposts.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

class HomeModel with ChangeNotifier {
  HomeModel(
      {@required this.authentication,
      @required this.dataService,
      this.homePosts,
      this.isLoading = true});

  final AuthenticationBase authentication;
  final DataService dataService;
  List<HomePost> homePosts;
  bool isLoading;
  bool requested;

  Future<void> updateData() async {
    try {
      updateWith(isLoading: true);
      User user = await authentication.currentUser();
      List<HomePost> homePosts = await dataService.getHomePosts(user);
      updateWith(isLoading: false, homePosts: homePosts);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleLike(Post post) async {
    try {
      User user = await authentication.currentUser();
      Post updatedPost = await dataService.toggleLikePost(user, post);
      updateHomePostWith(updatedPost);
    } catch (e) {
      rethrow;
    }
  }

  void updateWith({List<HomePost> homePosts, bool isLoading, bool requested}) {
    this.homePosts = homePosts ?? this.homePosts;
    this.isLoading = isLoading ?? this.isLoading;
    this.requested = requested ?? this.requested;
    notifyListeners();
  }

  void updateHomePostWith(Post post) {
    for (HomePost homePost in homePosts) {
      if (homePost.post.id == post.id) {
        homePost.post = post;
      }
    }
    notifyListeners();
  }
}
