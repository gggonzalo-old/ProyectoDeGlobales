import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/post.dart';

class Organizer {
  Organizer(
      {this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.posts = const [],
      this.events = const []});

  String id;
  String name;
  String description;
  String imageUrl;
  List<Post> posts;
  List<Event> events;

  factory Organizer.fromJson(Map<String, dynamic> json) {
    List posts = json["posts"];
    List events = json["events"];

    if (posts != null) {
      posts = posts
          .map((repoJson) => Post.fromJson(repoJson))
          .toList(growable: false);
    }

    if (events != null) {
      events = events
          .map((repoJson) => Event.fromJson(repoJson))
          .toList(growable: false);
    }

    return new Organizer(
      id: json["_id"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["imageURL"],
      posts: posts,
      events: events,
    );
  }
}
