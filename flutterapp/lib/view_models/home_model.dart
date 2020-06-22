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
      this.isLoading = true,
      this.isLoadingLike = false,
      this.isLoadingBookMarked = false});

  final AuthenticationBase authentication;
  final DataService dataService;
  List<Post> posts;
  bool isLoading;
  bool isLoadingLike;
  bool isLoadingBookMarked;

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
      updateWith(isLoadingLike: true);
      User user = await authentication.currentUser();
      Post updatedPost = await dataService.toggleLikePost(user, post);
      updateHomePostWith(updatedPost);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoadingLike: false);
    }
  }

  Future<void> toggleBookmark(Post post) async {
    try {
      updateWith(isLoadingBookMarked: true);
      User user = await authentication.currentUser();
      Post updatedPost = await dataService.toggleUserPostBookmark(user, post);
      updateHomePostWith(updatedPost);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoadingBookMarked: false);
    }
  }

  Future<void> updatePost(Post post) async {
    try {
      if (post != null) {
        updateWith(isLoadingBookMarked: true, isLoadingLike: true);
        User user = await authentication.currentUser();
        Post updatedPost = await dataService.getPost(user, post);
        updateHomePostWith(updatedPost);
      }
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoadingBookMarked: false, isLoadingLike: false);
    }
  }

  void updateWith(
      {List<Post> posts,
      bool isLoading,
      bool isLoadingLike,
      bool isLoadingBookMarked}) {
    this.posts = posts ?? this.posts;
    this.isLoading = isLoading ?? this.isLoading;
    this.isLoadingLike = isLoadingLike ?? this.isLoadingLike;
    this.isLoadingBookMarked = isLoadingBookMarked ?? this.isLoadingBookMarked;

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
