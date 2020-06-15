import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

class PostDetailModel with ChangeNotifier {
  PostDetailModel({
    @required this.authentication,
    @required this.dataService,
    this.post,
    this.isLoading = false,
  });

  final AuthenticationBase authentication;
  final DataService dataService;
  Post post;
  bool isLoading;
  bool requested;

  Future<void> updatePost() async {
    try {
      updateWith(isLoading: true);
      Post post = await dataService.getPost(this.post);
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
      Post updatedPost = await dataService.toggleLikePost(user, this.post);
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
      User user = await authentication.currentUser();
      await dataService.createCommentPost(this.post, user, comment);
      await updatePost();
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateWith({bool isLoading, Post post}) {
    this.post = post ?? this.post;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }

  void updateHomePostWith(Post post) {
    this.post = post;
    notifyListeners();
  }
}
