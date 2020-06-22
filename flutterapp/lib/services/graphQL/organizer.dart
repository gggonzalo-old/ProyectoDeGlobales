import 'package:flutterapp/models/organizer.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Organizer toOrganizer(QueryResult queryResult) {
  if (queryResult.hasException) {
    throw Exception();
  }
  return Organizer.fromJson(queryResult.data["organizer"]);
}
