import 'package:flutter/material.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/prize.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/pages/event_details.dart';
import 'package:flutterapp/pages/events.dart';
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
  static Widget create(BuildContext context, {User user}) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authenticaion =
        Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<ProfileModel>.value(
      value: ProfileModel(
          authentication: authenticaion, dataService: dataService, user: user),
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
        length: model.isCurrentUser ? 3 : 2,
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
          body: ListView(
            shrinkWrap: true,
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
                  tabs: _buildTabList(),
                ),
              ),
              Container(
                height: 300,
                child: TabBarView(
                  children: _buildTabViewItems(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabList() {
    return model.isCurrentUser
        ? <Widget>[
            Tab(
              icon: Icon(
                Icons.photo_size_select_actual,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.bookmark,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.card_giftcard,
              ),
            ),
          ]
        : <Widget>[
            Tab(
              icon: Icon(
                Icons.photo_size_select_actual,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.bookmark,
              ),
            ),
          ];
  }

  List<Widget> _buildTabViewItems() {
    return model.isCurrentUser
        ? <Widget>[
            model.user.posts.isEmpty
                ? Center(child: Text("Empty posts list"))
                : GridView.count(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    children: List.generate(
                      model.user.posts.length,
                      (index) => _buildPostListItem(
                        model.user.posts[index],
                      ),
                    ),
                  ),
            model.user.bookmarkedPosts.isEmpty
                ? Center(child: Text("Empty favorite posts list"))
                : GridView.count(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    children: List.generate(
                      model.user.bookmarkedPosts.length,
                      (index) => _buildPostListItem(
                        model.user.bookmarkedPosts[index],
                      ),
                    ),
                  ),
            model.user.prizesClaimed.isEmpty
                ? Center(
                    child: Text("Empty prices list"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.user.prizesClaimed.length,
                    itemBuilder: (context, index) {
                      return _buildPrizeClaimedListItem(
                        context,
                        model.user.prizesClaimed[index],
                      );
                    },
                  ),
          ]
        : <Widget>[
            model.user.posts.isEmpty
                ? Center(child: Text("Empty posts list"))
                : GridView.count(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    children: List.generate(
                      model.user.posts.length,
                      (index) => _buildPostListItem(
                        model.user.posts[index],
                      ),
                    ),
                  ),
            model.user.bookmarkedPosts.isEmpty
                ? Center(child: Text("Empty favorite posts list"))
                : GridView.count(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    children: List.generate(
                      model.user.bookmarkedPosts.length,
                      (index) => _buildFavoritePostListItem(
                        model.user.bookmarkedPosts[index],
                      ),
                    ),
                  )
          ];
  }

  Container _buildCollectionsRow() {
    return Container(
      height: 150.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: model.user.enrolledEvents.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsPage.create(
                      context, model.user.enrolledEvents[index]),
                ),
              )
            },
            child: Container(
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
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
                  )
                ],
              ),
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
            "Events(${model.user.enrolledEvents.length})",
            style: Theme.of(context).textTheme.headline6,
          ),
          FlatButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventsPage.create(context),
                ),
              )
            },
            child: Text(
              "Search events",
              style: TextStyle(color: Theme.of(context).textSelectionColor),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPrizeClaimedListItem(BuildContext context, Prize prize) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(5.0),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: CachedNetworkImageProvider(prize.imageUrl),
                        fit: BoxFit.fill,
                      ),
                      height: 300,
                      width: double.infinity,
                    ),
                    Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: GestureDetector(
                        onTap: () => {
                          _showImageDialog(context, prize.qrUrl),
                        },
                        child: Container(
                          child: Image(
                            image: CachedNetworkImageProvider(prize.qrUrl),
                            fit: BoxFit.fill,
                          ),
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20.0,
                      right: 10.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        color: Theme.of(context).cardColor,
                        child: Text(prize.cost.toString()),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        prize.name,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(prize.description),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritePostListItem(Post post) {
    return Container(
      padding: EdgeInsets.only(bottom: 40),
      child: PNetworkImage(post.imageUrl, fit: BoxFit.fill),
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
                  builder: (context) => SettingsPage(),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: Text(
                      "Estudiante de la Universidad Nacional de Costa Rica",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
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
                              model.user.points.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Points".toUpperCase(),
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
          model.isCurrentUser
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(right: 50.0, top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () => {
                          model.user.isFriend
                              ? model.removeFriend()
                              : model.addFriend()
                        },
                        color: model.user.isFriend ? Colors.red : Colors.blue,
                        child: Text(
                          model.user.isFriend ? "Remove" : "Add",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  _showImageDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: PNetworkImage(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
