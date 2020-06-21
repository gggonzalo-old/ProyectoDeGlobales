import 'package:flutterapp/models/prize.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

List<Prize> toPrizes(QueryResult queryResult) {
  if (queryResult.hasException) {
    throw Exception();
  }

  final List prizes = queryResult.data['prizes'];

  return prizes
      .map((repoJson) => Prize.fromJson(repoJson))
      .toList(growable: true);
}
