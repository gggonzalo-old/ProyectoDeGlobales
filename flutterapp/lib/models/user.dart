import 'package:flutter/widgets.dart';
import 'package:flutterapp/models/post.dart';

class User with ChangeNotifier {
  User(
      {this.id,
      this.name,
      this.username,
      this.photoUrl,
      this.friends,
      this.posts});
  String id;
  String name;
  String username;
  String photoUrl;
  List<User> friends;
  List<Post> posts;

  factory User.fromJson(Map<String, dynamic> json) {
    List friends = json["friends"];
    List posts = json["posts"];

    if (friends != null) {
      friends = friends
          .map((repoJson) => User.fromJson(repoJson))
          .toList(growable: false);
    }
    if (posts != null) {
      posts = posts
          .map((repoJson) => Post.fromJson(repoJson))
          .toList(growable: false);
    }

    return new User(
      id: json["_id"],
      //name: DateTime.parse(json["createdAt"]),
      name: json["name"],
      username: json["username"],
      photoUrl: json["photoUrl"],
      friends: friends,
      posts: posts,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        //"name": createdAt.toIso8601String(),
        "name": name,
        "username": username,
      };
}
