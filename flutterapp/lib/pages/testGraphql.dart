import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TestGraphQL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: "https://backend-globales.herokuapp.com/graphql");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
          cache: NormalizedInMemoryCache(
              dataIdFromObject: typenameDataIdFromObject),
          link: httpLink),
    );

    return GraphQLProvider(
      child: TestPage(),
      client: client,
    );
  }
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hola"),
      ),
      body: Query(
        options: QueryOptions(
          documentNode: gql(""" 
          query{
            getUsers {
              name
  }
}
      """),
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.loading || result.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List users = result.data['getUsers'];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final repository = users[index];

              return Text(repository['name']);
            },
          );
        },
      ),
    );
  }
}
