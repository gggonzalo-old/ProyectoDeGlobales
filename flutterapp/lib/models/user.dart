import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/prize.dart';

class User {
  User(
      {this.id,
      this.name,
      this.username,
      this.photoUrl,
      this.isFriend,
      this.friends,
      this.posts,
      this.points,
      this.prizesClaimed = const [],
      this.favoritePosts = const [],
      this.enrolledEvents = const [],
      this.eventTags = const []});
  String id;
  String name;
  String username;
  String photoUrl;
  bool isFriend;
  int points;
  List<User> friends;
  List<Post> posts;
  List<Prize> prizesClaimed;
  List<Post> favoritePosts;
  List<Event> enrolledEvents;
  List<String> eventTags;

  factory User.fromJson(Map<String, dynamic> json) {
    List friends = json["friends"];
    List posts = json["posts"];
    List prizesClaimed = json["prizesClaimed"];
    List favoritePosts = json["favorites"];
    List enrolledEvents = json["enrolledEvents"];
    List eventTags = json["eventTags"];

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

    if (prizesClaimed != null) {
      prizesClaimed = prizesClaimed
          .map((repoJson) => Prize.fromJson(repoJson))
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

    if (eventTags != null) {
      eventTags = eventTags
          .map((repoJson) => repoJson.toString())
          .toList(growable: true);
    }

    return new User(
        id: json["_id"],
        //name: DateTime.parse(json["createdAt"]),
        name: json["name"],
        username: json["username"],
        photoUrl: json["photoURL"],
        isFriend: json["isFriend"],
        points: json["points"],
        friends: friends,
        posts: posts,
        prizesClaimed: prizesClaimed,
        favoritePosts: favoritePosts,
        enrolledEvents: enrolledEvents,
        eventTags: eventTags);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        //"name": createdAt.toIso8601String(),
        "name": name,
        "username": username,
      };
}
