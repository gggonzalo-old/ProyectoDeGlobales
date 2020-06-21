import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterapp/graphQL/events/mutations.dart';
import 'package:flutterapp/graphQL/events/queries.dart';
import 'package:flutterapp/graphQL/posts/mutations.dart';
import 'package:flutterapp/graphQL/posts/queries.dart';
import 'package:flutterapp/graphQL/prizes/mutations.dart';
import 'package:flutterapp/graphQL/prizes/queries.dart';
import 'package:flutterapp/graphQL/users/mutations.dart';
import 'package:flutterapp/graphQL/users/queries.dart';
import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/prize.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/graphQL/events.dart';
import 'package:flutterapp/services/graphQL/posts.dart';
import 'package:flutterapp/services/graphQL/prizes.dart';
import 'package:flutterapp/services/graphQL/users.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../data.dart';

class GraphQLService implements DataService {
  static HttpLink _httpLink = HttpLink(
    uri: 'https://backend-globales.herokuapp.com/graphql',
  );

  final GraphQLClient _client = GraphQLClient(
      cache:
          NormalizedInMemoryCache(dataIdFromObject: typenameDataIdFromObject),
      link: _httpLink);

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
  Future<User> getUser(User user) {
    final String queryParameter = getUserQuery(user.id);
    return _client.mutate(_mutationOptions(queryParameter)).then(toUser);
  }

  @override
  Future<User> getUserTags(User user) {
    final String queryParameter = getUserTagsQuery(user.id);
    return _client.mutate(_mutationOptions(queryParameter)).then(toUserTags);
  }

  @override
  Future<Event> getEvent(User user, Event event) {
    final String queryParameter = getEventQuery(event.id);
    return _client
        .mutate(_mutationOptions(queryParameter))
        .then((value) => toEvent(value, user));
  }

  @override
  Future<Post> getPost(User user, Post post) {
    final String queryParameter = getPostQuery(post.id);
    return _client
        .mutate(_mutationOptions(queryParameter))
        .then((value) => toPost(value, "post", user));
  }

  @override
  Future<List<User>> getUsers(User user, String search) {
    final String queryParameter = getUsersQuery(user.id.toString(), search);
    return _client.mutate(_mutationOptions(queryParameter)).then(toUsers);
  }

  @override
  Future<List<Post>> getPostsByHashTag(String search) {
    final String queryParameter = getPostsByHashtagQuery(search);
    return _client.mutate(_mutationOptions(queryParameter)).then(toPosts);
  }

  @override
  Future<List<Post>> getHomePosts(User user) async {
    final String queryParameter = getHomePostsQuery(user.id);
    return await _client
        .mutate(_mutationOptions(queryParameter))
        .then((value) => toHomePosts(value, user));
  }

  @override
  Future<List<Event>> getEvents(String search) {
    final String queryParameter = getEventsQuery(search);
    return _client.query(_queryOptions(queryParameter)).then(toEvents);
  }

  @override
  Future<List<Prize>> getPrizes(String search) {
    final String queryParameter = getPrizesQuery(search);
    return _client.query(_queryOptions(queryParameter)).then(toPrizes);
  }

  @override
  Future<void> createUser(User user) {
    final String queryParameter =
        createUserMutation(user.id, user.username, user.name, user.photoUrl);
    _client.query(_queryOptions(queryParameter));
  }

  @override
  Future<void> createPost(User user, Post post) async {
    final String queryParameter = createUserPostMutation(
        user.id, post.description, post.eventTag, post.imageUrl);
    await _client.query(_queryOptions(queryParameter));
  }

  @override
  Future<Post> createCommentPost(Post post, User user, String comment) async {
    final String queryParameter =
        createCommentPostMutation(post.id, user.id, comment);
    await _client.mutate(_mutationOptions(queryParameter));
    return getPost(user, post);
  }

  @override
  Future<Post> toggleLikePost(User user, Post post) async {
    final String queryParameter = toggleLikePostMutation(user.id, post.id);
    await _client.mutate(_mutationOptions(queryParameter));
    return getPost(user, post);
  }

  @override
  Future<Event> toggleEventEnrollment(User user, Event event) async {
    final String queryParameter =
        toggleEventEnrollmentMutation(user.id, event.id);
    await _client.mutate(_mutationOptions(queryParameter));
    return getEvent(user, event);
  }

  @override
  Future<Event> toggleEventInInterested(User user, Event event) async {
    final String queryParameter =
        toggleEventInInterestedMutation(user.id, event.id);
    await _client.mutate(_mutationOptions(queryParameter));
    return getEvent(user, event);
  }

  @override
  Future<bool> claimPrize(User user, Prize prize) async {
    final String queryParameter = claimPrizeMutation(prize.id, user.id);
    bool result;
    await _client.mutate(_mutationOptions(queryParameter)).then((value) => result = value.data["claimPrize"]);
    return result;
  }

  @override
  Future<void> addFriend(User user, User friend) {
    final String queryParameter = addFriendMutation(user.id, friend.id);
    return _client.mutate(_mutationOptions(queryParameter));
  }
}
