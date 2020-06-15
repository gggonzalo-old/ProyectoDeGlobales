import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/homeposts.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

class PostDetailModel with ChangeNotifier {
  PostDetailModel({
    @required this.authentication,
    @required this.dataService,
    this.homePost,
    this.isLoading = false,
  });

  final AuthenticationBase authentication;
  final DataService dataService;
  HomePost homePost;
  bool isLoading;
  bool requested;

  Future<void> updatePost() async {
    try {
      updateWith(isLoading: true);
      Post post = await dataService.getPost(homePost.post);
      updateWith(post: post);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  Future<void> toggleLike() async {
    try {
      updateWith(isLoading: true);
      User user = await authentication.currentUser();
      Post updatedPost = await dataService.toggleLikePost(user, homePost.post);
      updateHomePostWith(updatedPost);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  Future<void> createComment(String comment) async {
    try {
      updateWith(isLoading: true);
      await dataService.createCommentPost(homePost.post, comment, User());
      await updatePost();
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateWith({bool isLoading, Post post}) {
    this.homePost.post = post ?? this.homePost.post;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }

  void updateHomePostWith(Post post) {
    homePost.post = post;
    notifyListeners();
  }
}
