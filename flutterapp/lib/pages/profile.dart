import 'package:flutter/material.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/prize.dart';
import 'package:flutterapp/pages/network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterapp/pages/post_details.dart';
import 'package:flutterapp/pages/settings.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/view_models/profile_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, @required this.model}) : super(key: key);
  final ProfileModel model;
  static Widget create(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authenticaion =
        Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<ProfileModel>.value(
      value:
          ProfileModel(authentication: authenticaion, dataService: dataService),
      child: Consumer<ProfileModel>(
        builder: (context, model, _) => ProfilePage(
          model: model,
        ),
      ),
    );
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileModel get model => widget.model;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.updateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return model.isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _buildProfile(context);
  }

  Widget _buildProfile(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    1,
                    (index) => _buildHeader(context),
                  ),
                ),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              model.user.enrolledEvents.isEmpty
                  ? SizedBox()
                  : _buildSectionHeader(context),
              model.user.enrolledEvents.isEmpty
                  ? SizedBox()
                  : _buildCollectionsRow(),
              Container(
                color: Theme.of(context).cardColor,
                child: TabBar(
                  indicatorColor: Theme.of(context).colorScheme.onSurface,
                  labelColor: Theme.of(context).cursorColor,
                  unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.photo_size_select_actual,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.card_giftcard,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    model.user.posts.isEmpty
                        ? Center(child: Text("Empty posts list"))
                        : GridView.count(
                            padding: EdgeInsets.zero,
                            crossAxisCount: 2,
                            children: List.generate(
                              model.user.posts.length,
                              (index) => _buildPostListItem(
                                model.user.posts[index],
                              ),
                            ),
                          ),
                    model.user.prizesClaimed.isEmpty
                        ? Center(child: Text("Empty prices list"))
                        : GridView.count(
                            padding: EdgeInsets.zero,
                            crossAxisCount: 1,
                            children: List.generate(
                              model.user.prizesClaimed.length,
                              (index) => _buildFavoriteListItem(
                                model.user.prizesClaimed[index],
                              ),
                            ),
                          ),
                    /*ListView(
                      padding: EdgeInsets.zero,
                      children: List.generate(
                          model.user.favoritePosts.length,
                          (index) => _buildFavoriteListItem(
                              model.user.favoritePosts[index])),
                    )*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildCollectionsRow() {
    return Container(
      height: 200.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: model.user.enrolledEvents.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            width: 150.0,
            height: 200.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: PNetworkImage(
                        model.user.enrolledEvents[index].imageUrl,
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  model.user.enrolledEvents[index].name,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Container _buildSectionHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Events",
            style: Theme.of(context).textTheme.headline6,
          ),
          FlatButton(
            onPressed: () {},
            child: Text(
              "Search events",
              style: TextStyle(color: Theme.of(context).textSelectionColor),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFavoriteListItem(Prize prize) {
    return Container(
      padding: EdgeInsets.only(bottom: 4.0),
      child: PNetworkImage(
        prize.qrUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPostListItem(Post post) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostDetailsPage.create(
              context,
              post,
            ),
          ),
        )
      },
      child: Container(
        height: 150.0,
        child: PNetworkImage(
          post.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
      height: 240.0,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: 8,
                  child: Icon(Icons.settings),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: Theme.of(context).cardColor,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    model.user.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text("UI/UX designer | Angular xddd"),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              model.user.posts.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Posts".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              model.user.friends.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Friends".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              model.user.enrolledEvents.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Enrolled events".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 5.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage:
                      CachedNetworkImageProvider(model.user.photoUrl),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
