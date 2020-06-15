import 'package:flutterapp/models/user.dart';

class Comment {
  User user;
  String date;
  String content;

  Comment({
    this.user,
    this.date,
    this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => new Comment(
        user: User.fromJson(json["user"]),
        date: json["date"],
        content: json["content"],
      );
}
