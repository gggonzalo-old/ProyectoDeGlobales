import 'package:flutterapp/models/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

User toUser(QueryResult queryResult) {
  if (queryResult.hasException) {
    throw Exception();
  }
  User user = User.fromJson(queryResult.data["user"]);
  user.posts.forEach((post) {
    post.owner = user;
  });
  return user;
}

List<User> toUsers(QueryResult queryResult) {
  if (queryResult.hasException) {
    throw Exception();
  }

  final List users = queryResult.data['users'];

  return users
      .map((repoJson) => User.fromJson(repoJson))
      .toList(growable: false);
}

User toUserTags(QueryResult queryResult) {
  if (queryResult.hasException) {
    throw Exception();
  }
  
  User user = User.fromJson(queryResult.data["user"]);

  return user;
}
