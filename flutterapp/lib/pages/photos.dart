import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterapp/pages/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'network_image.dart';

// InstaProfilePage
class InstaProfilePage extends StatefulWidget {
  @override
  _InstaProfilePageState createState() => _InstaProfilePageState();
}

class _InstaProfilePageState extends State<InstaProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  _buildHeaderProfile(context),
                ),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
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
                        Icons.favorite,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    GridView.count(
                        padding: EdgeInsets.zero,
                        crossAxisCount: 3,
                        children: List.generate(
                            100, (index) => _buildPostListItem())),
                    ListView(
                      padding: EdgeInsets.zero,
                      children: List.generate(
                          100, (index) => _buildFavoriteListItem()),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHeaderProfile(BuildContext context) {
    List<Widget> profileHeader = List<Widget>();

    profileHeader.add(_buildHeader(context));

    return profileHeader;
  }

  Widget _buildFavoriteListItem() {
    return Container(
      padding: EdgeInsets.only(bottom: 4.0),
      child: PNetworkImage(
        "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPostListItem() {
    return Container(
      height: 150.0,
      child: PNetworkImage(
        "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media",
        fit: BoxFit.cover,
      ),
    );
  }

  Container _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      height: 240.0,
      child: Stack(
        children: <Widget>[
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
                    "Gonzalo González",
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
                              "302",
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
                              "10.3K",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Followers".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "120",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Following".toUpperCase(),
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
                  backgroundImage: CachedNetworkImageProvider(
                      "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
