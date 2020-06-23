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
  static Widget create(BuildContext context, {String eventTag}) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authentication =
        Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<SearchModel>.value(
      value: SearchModel(
          dataService: dataService,
          authentication: authentication,
          search: eventTag),
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

  void changeFollowStatus() {}
  SearchModel get searchModel => widget.searchModel;

  void _toggleSearchType(SearchType searchType) {
    searchModel.toggleSearchType(searchType);
    searchModel.searchController.clear();
  }

  @override
  void initState() {
    super.initState();

    if (searchModel.search != "") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        searchModel.searchController.text = searchModel.search;
        searchModel.updateSearch(searchModel.search);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.search),
          backgroundColor: Theme.of(context).hoverColor,
          title: TextField(
            style: TextStyle(color: Colors.white),
            controller: searchModel.searchController,
            onChanged: searchModel.updateSearch,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "#",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                ),
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
