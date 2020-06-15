import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/post.dart';

class User {
  User(
      {this.id,
      this.name,
      this.username,
      this.photoUrl,
      this.isFriend,
      this.friends,
      this.posts,
      this.favoritePosts = const [],
      this.enrolledEvents = const []});
  String id;
  String name;
  String username;
  String photoUrl;
  bool isFriend;
  List<User> friends;
  List<Post> posts;
  List<Post> favoritePosts;
  List<Event> enrolledEvents;

  factory User.fromJson(Map<String, dynamic> json) {
    List friends = json["friends"];
    List posts = json["posts"];
    List favoritePosts = json["favorites"];
    List enrolledEvents = json["enrolledEvents"];

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

    if (favoritePosts != null) {
      favoritePosts = favoritePosts
          .map((repoJson) => Post.fromJson(repoJson))
          .toList(growable: false);
    }

    if (enrolledEvents != null) {
      enrolledEvents = enrolledEvents
          .map((repoJson) => Event.fromJson(repoJson))
          .toList(growable: false);
    }

    return new User(
        id: json["_id"],
        //name: DateTime.parse(json["createdAt"]),
        name: json["name"],
        username: json["username"],
        photoUrl: json["photoUrl"],
        isFriend: json["isFriend"],
        friends: friends,
        posts: posts,
        favoritePosts: favoritePosts,
        enrolledEvents: enrolledEvents);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        //"name": createdAt.toIso8601String(),
        "name": name,
        "username": username,
      };
}
