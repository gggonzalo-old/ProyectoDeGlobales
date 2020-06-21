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
    this.comment,
    this.isLoading = true,
  });

  final AuthenticationBase authentication;
  final DataService dataService;
  Post post;
  String comment;
  bool isLoading;
  bool requested;
  TextEditingController commentController = TextEditingController();

  Future<void> updatePost() async {
    try {
      updateWith(isLoading: true);
      User user = await authentication.currentUser();
      Post post = await dataService.getPost(user, this.post);
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

  Future<void> createComment() async {
    try {
      updateWith(isLoading: true);
      User user = await authentication.currentUser();
      await dataService.createCommentPost(this.post, user, this.comment);
      commentController.clear();
      await updatePost();
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateComment(String comment) {
    updateWith(comment: comment);
  }

  void updateWith({bool isLoading, String comment, Post post}) {
    this.post = post ?? this.post;
    this.comment = comment ?? this.comment;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }

  void updateHomePostWith(Post post) {
    this.post = post;
    notifyListeners();
  }
}
