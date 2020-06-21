class Prize {
  String id;
  String name;
  String description;
  int cost;
  String imageUrl;
  String qrUrl;

  Prize(
      {this.id,
      this.name,
      this.description,
      this.cost,
      this.imageUrl,
      this.qrUrl});

  factory Prize.fromJson(Map<String, dynamic> json) {
    return Prize(
      id: json["_id"],
      name: json["name"],
      description: json["description"],
      cost: json["cost"],
      imageUrl: json["imageURL"],
      qrUrl: json["QRURL"],
    );
  }
}
