class User {
  String id;
  String name;
  String username;

  User({
    this.id,
    this.name,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json["_id"],
        //name: DateTime.parse(json["createdAt"]),
        name: json["name"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        //"name": createdAt.toIso8601String(),
        "name": name,
        "username": username,
      };
}
