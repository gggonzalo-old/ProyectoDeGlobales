import 'package:flutterapp/models/comment.dart';
import 'package:flutterapp/models/user.dart';

class Post {
  Post(
      {this.id,
      this.date,
      this.description,
      this.imageUrl,
      this.eventTag, 
      this.isVerified,
      this.isLiked = false,
      this.usersWhoLiked = const [],
      this.comments = const [],
      this.owner});
  String id;
  String date;
  String description;
  String imageUrl;
  String eventTag;
  bool isVerified;
  bool isLiked;
  List<User> usersWhoLiked;
  List<Comment> comments;
  User owner;

  factory Post.fromJson(Map<String, dynamic> json) {
    List usersWhoLiked = json["usersWhoLiked"];
    List comments = json["comments"];
    User owner;

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

    if (json["owner"] != null) {
      owner = User.fromJson(json["owner"]);
    }

    return Post(
        id: json["_id"],
        date: json["date"],
        description: json["description"],
        imageUrl: json["imageURL"],
        eventTag: json["eventTag"],
        isVerified: json["verified"],
        isLiked: false,
        usersWhoLiked: usersWhoLiked,
        comments: comments,
        owner: owner
        //name: DateTime.parse(json["createdAt"]),
        );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        //"name": createdAt.toIso8601String(),
      };
}
