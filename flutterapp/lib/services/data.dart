import 'package:flutterapp/graphQL/posts/mutations.dart';
import 'package:flutterapp/graphQL/users/mutations.dart';
import 'package:flutterapp/graphQL/users/queries.dart';
import 'package:flutterapp/graphQL/posts/queries.dart';
import 'package:flutterapp/models/homeposts.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class DataService {
  Future<List<User>> getUsers(User user, String search);
  Future<List<Post>> getPosts(User user, String search);
  Future<List<HomePost>> getHomePosts(User user);
  Future<void> createUser(User user);
  Future<Post> toggleLikePost(User user, Post post);
  Future<Post> getPost(Post post);
  Future<void> createCommentPost(Post post, String comment, User user);
  Future<void> addFriend(User user, User friend);
}

class GraphQLService implements DataService {
  static HttpLink _httpLink = HttpLink(
    uri: 'https://backend-globales.herokuapp.com/graphql',
  );

  final GraphQLClient _client = GraphQLClient(
      cache:
          NormalizedInMemoryCache(dataIdFromObject: typenameDataIdFromObject),
      link: _httpLink);

  Post _toPost(QueryResult queryResult, String tag, User user) {
    if (queryResult.hasException) {
      throw Exception();
    }

    Post postFromJson = Post.fromJson(queryResult.data[tag]);

    postFromJson.usersWhoLiked.forEach((userWhoLiked) {
      if (userWhoLiked.id == user.id) {
        postFromJson.isLiked = true;
        return;
      }
    });

    return postFromJson;
  }

  List<User> _toUsers(QueryResult queryResult) {
    if (queryResult.hasException) {
      throw Exception();
    }

    final List users = queryResult.data['users'];

    return users
        .map((repoJson) => User.fromJson(repoJson))
        .toList(growable: false);
  }

  List<Post> _toPosts(QueryResult queryResult) {
    if (queryResult.hasException) {
      throw Exception();
    }

    final List posts = queryResult.data['posts'];

    return posts
        .map((repoJson) => Post.fromJson(repoJson))
        .toList(growable: false);
  }

  List<HomePost> _toHomePosts(QueryResult queryResult, User user) {
    if (queryResult.hasException) {
      throw Exception();
    }

    User userFromJson = User.fromJson(queryResult.data['user']);
    List<HomePost> homePosts = List<HomePost>();

    userFromJson.friends.forEach((friend) {
      friend.posts.forEach((post) {
        for (User userLiked in post.usersWhoLiked) {
          if (user.id == userLiked.id) {
            post.isLiked = true;
          }
        }

        homePosts.add(HomePost(post: post, user: user));
      });
    });

    homePosts.sort((a, b) => b.post.date.compareTo(a.post.date));

    return homePosts;
  }

  QueryOptions _queryOptions(String query) {
    return QueryOptions(
      documentNode: gql(query),
    );
  }

  MutationOptions _mutationOptions(String mutation) {
    return MutationOptions(
      documentNode: gql(mutation),
    );
  }

  @override
  Future<List<User>> getUsers(User user, String search) {
    final String queryParameter = readUsers(user.id.toString(), search);
    return _client.mutate(_mutationOptions(queryParameter)).then(_toUsers);
  }

  @override
  Future<List<Post>> getPosts(User user, String search) {
    final String queryParameter =
        getPostsByHashtagQuery(user.id.toString(), search);
    return _client.query(_queryOptions(queryParameter)).then(_toPosts);
  }

  @override
  Future<List<HomePost>> getHomePosts(User user) {
    final String queryParameter = getHomePostsQuery(user.id);
    return _client
        .mutate(_mutationOptions(queryParameter))
        .then((value) => _toHomePosts(value, user));
  }

  @override
  Future<void> createUser(User user) {
    final String queryParameter =
        createUserMutation(user.id, user.username, user.name, user.photoUrl);
    _client.query(_queryOptions(queryParameter));
  }

  @override
  Future<Post> toggleLikePost(User user, Post post) async {
    final String queryParameter = toggleLikePostMutation(user.id, post.id);
    return _client
        .mutate(_mutationOptions(queryParameter))
        .then((value) => _toPost(value, "toggleUserPostLike", user));
  }

  @override
  Future<Post> getPost(Post post) {
    final String queryParameter = getPostQuery(post.id);
    return _client
        .mutate(_mutationOptions(queryParameter))
        .then((value) => _toPost(value, "post", User()));
  }

  @override
  Future<Post> createCommentPost(Post post, String comment, User user) {
    final String queryParameter = createCommentPostMutation(post.id, comment);
    return _client
        .query(_queryOptions(queryParameter))
        .then((value) => _toPost(value, "post", user));
  }

  @override
  Future<void> addFriend(User user, User friend) {
    final String queryParameter = addFriendMutation(user.id, friend.id);
    return _client.mutate(_mutationOptions(queryParameter));
  }
}
