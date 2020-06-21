import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Event toEvent(QueryResult queryResult, User user) {
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

List<Event> toEvents(QueryResult queryResult) {
  if (queryResult.hasException) {
    throw Exception();
  }

  final List events = queryResult.data['events'];

  return events
      .map((repoJson) => Event.fromJson(repoJson))
      .toList(growable: true);
}
