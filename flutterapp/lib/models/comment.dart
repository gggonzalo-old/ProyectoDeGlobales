import 'package:flutterapp/models/user.dart';

class Comment {
  User user;
  String date;
  String context;

  Comment({
    this.user,
    this.date,
    this.context,
  });
}