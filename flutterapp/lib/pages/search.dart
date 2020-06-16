import 'package:flutter/material.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/view_models/search_model.dart';
import 'package:flutterapp/widgets/users_list_widget.dart';
import 'package:flutterapp/widgets/posts_list_widget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, @required this.searchModel}) : super(key: key);
  final SearchModel searchModel;
  static Widget create(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authentication = Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<SearchModel>(
      create: (_) => SearchModel(dataService: dataService, authentication: authentication),
      child: Consumer<SearchModel>(
        builder: (context, model, _) => SearchPage(
          searchModel: model,
        ),
      ),
    );
  }

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  /*


  BUSCAR FLAPPY SEARCH BAR


  */

  TextEditingController _search = TextEditingController();

  void changeFollowStatus() {}
  SearchModel get searchModel => widget.searchModel;

  void _toggleSearchType(SearchType searchType) {
    searchModel.toggleSearchType(searchType);
    _search.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.search),
          title: TextField(
            controller: _search,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            onChanged: searchModel.updateSearch,
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.photo_library)),
              Tab(
                icon: Icon(Icons.person),
              ),
            ],
            onTap: (index) => {
              if (index == 0)
                {_toggleSearchType(SearchType.posts)}
              else
                {_toggleSearchType(SearchType.users)}
            },
          ),
        ),
        body: TabBarView(
          children: [
            PostsList(model: searchModel),
            UsersList(model: searchModel)
          ],
        ),
      ),
    );
  }
}
