import 'package:flutterapp/graphQL/events/mutations.dart';
import 'package:flutterapp/graphQL/events/queries.dart';
import 'package:flutterapp/graphQL/posts/mutations.dart';
import 'package:flutterapp/graphQL/users/mutations.dart';
import 'package:flutterapp/graphQL/users/queries.dart';
import 'package:flutterapp/graphQL/posts/queries.dart';
import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class DataService {
  Future<User> getUser(User user);
  Future<List<User>> getUsers(User user, String search);
  Future<List<Post>> getPostsByHashTag(String search);
  Future<List<Post>> getHomePosts(User user);
  Future<List<Event>> getEvents(String search);
  Future<void> createUser(User user);
  Future<Post> toggleLikePost(User user, Post post);
  Future<Post> getPost(User user, Post post);
  Future<void> createCommentPost(Post post, User user, String comment);
  Future<void> addFriend(User user, User friend);
  Future<Event> getEvent(User user, Event event);
  Future<Event> toggleEventEnrollment(User user, Event event);
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

  User _toUser(QueryResult queryResult) {
    if (queryResult.hasException) {
      throw Exception();
    }
    User user = User.fromJson(queryResult.data["user"]);
    user.posts.forEach((post) {
      post.owner = user;
    });
    return user;
  }

  Event _toEvent(QueryResult queryResult, User user) {
    if (queryResult.hasException) {
      throw Exception();
    }

    Event event = Event.fromJson(queryResult.data["event"]);

    event.usersEnrolled.forEach((userEnrolled) {
      if (userEnrolled.id == user.id) {
        event.isEnrolled = true;
        return;
      }
    });

    event.usersInterested.forEach((userInterested) {
      if (userInterested.id == user.id) {
        event.isInterested = true;
        return;
      }
    });

    return event;
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
        .toList(growable: true);
  }

  List<Post> _toHomePosts(QueryResult queryResult, User user) {
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
        post.owner = friend;
        posts.add(post);
      });
    });

    posts.sort((a, b) => b.date.compareTo(a.date));

    return posts;
  }

  List<Event> _toEvents(QueryResult queryResult) {
    if (queryResult.hasException) {
      throw Exception();
    }

    final List events = queryResult.data['events'];

    return events
        .map((repoJson) => Event.fromJson(repoJson))
        .toList(growable: true);
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
    final String queryParameter = getUsersQuery(user.id.toString(), search);
    return _client.mutate(_mutationOptions(queryParameter)).then(_toUsers);
  }

  @override
  Future<List<Post>> getPostsByHashTag(String search) {
    final String queryParameter = getPostsByHashtagQuery(search);
    return _client.mutate(_mutationOptions(queryParameter)).then(_toPosts);
  }

  @override
  Future<List<Post>> getHomePosts(User user) {
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
    await _client.mutate(_mutationOptions(queryParameter));
    return getPost(user, post);
  }

  @override
  Future<Post> getPost(User user, Post post) {
    final String queryParameter = getPostQuery(post.id);
    return _client
        .mutate(_mutationOptions(queryParameter))
        .then((value) => _toPost(value, "post", user));
  }

  @override
  Future<Post> createCommentPost(Post post, User user, String comment) async {
    final String queryParameter =
        createCommentPostMutation(post.id, user.id, comment);
    await _client.mutate(_mutationOptions(queryParameter));
    return getPost(user, post);
  }

  @override
  Future<void> addFriend(User user, User friend) {
    final String queryParameter = addFriendMutation(user.id, friend.id);
    return _client.mutate(_mutationOptions(queryParameter));
  }

  @override
  Future<List<Event>> getEvents(String search) {
    final String queryParameter = getEventsQuery(search);
    return _client.query(_queryOptions(queryParameter)).then(_toEvents);
  }

  @override
  Future<User> getUser(User user) {
    final String queryParameter = getUserQuery(user.id);
    return _client.mutate(_mutationOptions(queryParameter)).then(_toUser);
  }

  @override
  Future<Event> getEvent(User user, Event event) {
    final String queryParameter = getEventQuery(event.id);
    return _client
        .mutate(_mutationOptions(queryParameter))
        .then((value) => _toEvent(value, user));
  }

  @override
  Future<Event> toggleEventEnrollment(User user, Event event) async {
    final String queryParameter =
        toggleEventEnrollmentMutation(user.id, event.id);
    await _client.mutate(_mutationOptions(queryParameter));
    return getEvent(user, event);
  }
}
