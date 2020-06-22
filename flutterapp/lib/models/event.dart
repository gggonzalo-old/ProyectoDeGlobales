import 'package:flutterapp/models/organizer.dart';
import 'package:flutterapp/models/user.dart';
import 'package:intl/intl.dart';

class Event {
  Event({
    this.id,
    this.name,
    this.description,
    this.date,
    this.price = 0,
    this.place,
    this.imageUrl,
    this.isEnrolled,
    this.isInterested,
    this.usersEnrolled = const [],
    this.usersInterested = const [],
    this.owner,
  });
  String id;
  String name;
  String description;
  String date;
  int price;
  String place;
  String imageUrl;
  bool isEnrolled;
  bool isInterested;
  List<User> usersEnrolled;
  List<User> usersInterested;
  Organizer owner;

  factory Event.fromJson(Map<String, dynamic> json) {
    List usersEnrolled = json["usersEnrolled"];
    List usersInterested = json["usersInterested"];
    Organizer owner;

    if (usersEnrolled != null) {
      usersEnrolled = usersEnrolled
          .map((repoJson) => User.fromJson(repoJson))
          .toList(growable: false);
    }

    if (usersInterested != null) {
      usersInterested = usersInterested
          .map((repoJson) => User.fromJson(repoJson))
          .toList(growable: false);
    }

    if (json["owner"] != null) {
      owner = Organizer.fromJson(json["owner"]);
    }

    return Event(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        date: json["date"] == null
            ? ""
            : DateFormat('yyyy-MM-dd kk:mm').format(
                DateTime.parse(json["date"]),
              ),
        price: json["price"],
        place: json["place"],
        imageUrl: json["imageURL"],
        isEnrolled: false,
        isInterested: false,
        usersEnrolled: usersEnrolled,
        usersInterested: usersInterested,
        owner: owner
        //name: DateTime.parse(json["createdAt"]),
        );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        //"name": createdAt.toIso8601String(),
      };
}
