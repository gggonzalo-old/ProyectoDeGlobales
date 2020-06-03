import 'package:graphql/client.dart';

final HttpLink _httpLink = HttpLink(
  uri: 'https://backend-globales.herokuapp.com/graphql',
);

GraphQLClient _client;

GraphQLClient getGraphQLClient() {
  _client ??= GraphQLClient(
      cache:
          NormalizedInMemoryCache(dataIdFromObject: typenameDataIdFromObject),
      link: _httpLink);

  return _client;

}
