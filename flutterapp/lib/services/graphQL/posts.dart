import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Post toPost(QueryResult queryResult, String tag, User user) {
  if (queryResult.hasException) {
    throw Exception();
  }

  Post postFromJson = Post.fromJson(queryResult.data[tag]);

  postFromJson.usersWhoLiked.forEach((userWhoLiked) {
    if (userWhoLiked.id == user.id) {
      postFromJson.isLiked = true;
    }
  });
  user.bookmarkedPosts.forEach((element) {
    if (element.id == postFromJson.id) {
      postFromJson.isBookMarked = true;
      return;
    }
  });

  return postFromJson;
}

List<Post> toPosts(QueryResult queryResult) {
  if (queryResult.hasException) {
    throw Exception();
  }

  final List posts = queryResult.data['posts'];

  return posts
      .map((repoJson) => Post.fromJson(repoJson))
      .toList(growable: true);
}

List<Post> toHomePosts(QueryResult queryResult, User user) {
  if (queryResult.hasException) {
    throw Exception();
  }

  User userFromJson = User.fromJson(queryResult.data['user']);
  List<Post> posts = List<Post>();

  userFromJson.friends.forEach((friend) {
    friend.posts.forEach((post) {
      for (User userLiked in post.usersWhoLiked) {
        if (user.id == userLiked.id) {
          post.isLiked = true;
        }
      }
      for (Post bookMarkedPost in userFromJson.bookmarkedPosts) {
        if (bookMarkedPost.id == post.id) {
          post.isBookMarked = true;
        }
      }
      post.owner = friend;
      posts.add(post);
    });
  });

  posts.sort((a, b) => b.date.compareTo(a.date));

  return posts;
}
