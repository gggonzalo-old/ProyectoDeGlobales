import 'dart:async';

import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/network_utils/graphql_client.dart';
import 'package:graphql/client.dart';

class UserProvider {

  final String readUsers = """ 
    query {
      getUsers {
        _id,
        username,
        name
      }
    }
  """;

  List<User> _toUser(QueryResult queryResult) {
    if (queryResult.hasException) {
      throw Exception();
    }

    final List users = queryResult.data['getUsers'];

    return users
        .map((repoJson) => User.fromJson(repoJson))
        .toList(growable: false);
  }

  Future<List<User>> getUsers() {
    return getGraphQLClient().query(_queryOptions()).then(_toUser);
  }

  QueryOptions _queryOptions() {
    return QueryOptions(
      documentNode: gql(readUsers),
    );

  }
}

    /*QueryOptions(
      document: readRepositories,
      variables: <String, dynamic>{
        'nRepositories': 50,
      },
    );*/

/*
r'''
  query ReadRepositories($nRepositories: Int!) {
    viewer {
      repositories(last: $nRepositories) {
        nodes {
          name
          createdAt
          forkCount
        }
      }
    }
  }
'''-*/
