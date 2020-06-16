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

  factory Comment.fromJson(Map<String, dynamic> json) {
    User user;
    if (json["user"] != null) {
      user = User.fromJson(json["user"]);
    }

    return Comment(
      user: user,
      date: json["date"],
      content: json["content"],
    );
  }
}
