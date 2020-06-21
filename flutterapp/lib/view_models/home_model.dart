import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

class HomeModel with ChangeNotifier {
  HomeModel(
      {@required this.authentication,
      @required this.dataService,
      this.posts,
      this.isLoading = true});

  final AuthenticationBase authentication;
  final DataService dataService;
  List<Post> posts;
  bool isLoading;

  Future<void> updateData() async {
    try {
      updateWith(isLoading: true);
      User user = await authentication.currentUser();
      List<Post> posts = await dataService.getHomePosts(user);
      updateWith(isLoading: false, posts: posts);
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

  Future<void> updatePost(Post post) async {
    try {
      User user = await authentication.currentUser();
      Post updatedPost = await dataService.getPost(user, post);
      updateHomePostWith(updatedPost);
    } catch (e) {
      rethrow;
    }
  }

  void updateWith({List<Post> posts, bool isLoading}) {
    this.posts = posts ?? this.posts;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }

  void updateHomePostWith(Post newPost) {
    List<Post> newPosts = this.posts;
    for (Post post in posts) {
      if (post.id == newPost.id) {
        newPosts[posts.indexOf(post)] = newPost;
      }
    }
    updateWith(posts: newPosts);
  }
}
