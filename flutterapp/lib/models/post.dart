import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/comment.dart';
import 'package:flutterapp/models/user.dart';

class Post with ChangeNotifier {
  Post({
    this.id,
    this.date,
    this.description,
    this.imageUrl,
    this.isLiked = false,
    this.usersWhoLiked = const [],
    this.comments = const [],
  });
  String id;
  String date;
  String description;
  String imageUrl;
  bool isLiked;
  List<User> usersWhoLiked;
  List<Comment> comments;

  factory Post.fromJson(Map<String, dynamic> json) {
    
    List usersWhoLiked = json["usersWhoLiked"];
    List comments = json["comments"];

    if (usersWhoLiked != null) {
      usersWhoLiked = usersWhoLiked
          .map((repoJson) => User.fromJson(repoJson))
          .toList(growable: false);
    }

    if (comments != null) {
      comments = comments
          .map((repoJson) => Comment.fromJson(repoJson))
          .toList(growable: false);
    }
    
    return Post(
      id: json["_id"],
      date: json["date"],
      description: json["description"],
      imageUrl: json["imageUrl"],
      isLiked: false,
      usersWhoLiked: usersWhoLiked,
      comments: comments
      //name: DateTime.parse(json["createdAt"]),
      );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        //"name": createdAt.toIso8601String(),
      };
}

final List<String> stories = [
  'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media',
  'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media',
  'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media',
  'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media',
  'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media',
];
