import 'package:flutterapp/graphQL/users/mutations.dart';
import 'package:flutterapp/graphQL/users/queries.dart';
import 'package:flutterapp/graphQL/posts/queries.dart';
import 'package:flutterapp/models/homeposts.dart';
import 'package:flutterapp/models/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class DataService {
  Future<List<User>> getUsers();
  Future<List<HomePost>> getHomePosts(User user);
  Future<void> createUser(User user);
}

class GraphQLService implements DataService {
  static HttpLink _httpLink = HttpLink(
    uri: 'https://backend-globales.herokuapp.com/graphql',
  );

  final GraphQLClient _client = GraphQLClient(
      cache:
          NormalizedInMemoryCache(dataIdFromObject: typenameDataIdFromObject),
      link: _httpLink);

  List<User> _toUsers(QueryResult queryResult) {
    if (queryResult.hasException) {
      throw Exception();
    }

    final List users = queryResult.data['users'];

    return users
        .map((repoJson) => User.fromJson(repoJson))
        .toList(growable: false);
  }

  List<HomePost> _toPost(QueryResult queryResult) {
    if (queryResult.hasException) {
      throw Exception();
    }

    User user = User.fromJson(queryResult.data['user']);
    List homePosts = List<HomePost>();

    user.friends.forEach((user) {
      user.posts.forEach((post) {
        homePosts.add(HomePost(post: post, user: user));
      });
    });

    return homePosts;
  }

  QueryOptions _queryOptions(String query) {
    return QueryOptions(
      documentNode: gql(query),
    );
  }

  @override
  Future<List<User>> getUsers() {
    return _client.query(_queryOptions(readUsers)).then(_toUsers);
  }

  @override
  Future<List<HomePost>> getHomePosts(User user) {
    // cambiar por user id
    final String queryParameter = readHomePosts('"5ed71446115b22023470af3c"');
    return _client.query(_queryOptions(queryParameter)).then(_toPost);
  }

  @override
  Future<void> createUser(User user) {
    final String queryParameter = createUserMutation(user.id, user.username, user.name, user.photoUrl);
    _client.query(_queryOptions(queryParameter));
  }
}
