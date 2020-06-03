import 'package:flutter/material.dart';
import 'package:flutterapp/pages/network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatelessWidget {
  final List<Map> collections = [
    {
      "title": "Event 1",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media"
    },
    {
      "title": "Event 2",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media"
    },
    {
      "title": "Event 3",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media"
    },
    {
      "title": "Event 4",
      "image":
          "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.builder(
          itemCount: 7,
          itemBuilder: _mainListBuilder,
        ),
      ],
    );
  }

  Widget _mainListBuilder(BuildContext context, int index) {
    if (index == 0) return _buildHeader(context);
    if (index == 1) return _buildSectionHeader(context);
    if (index == 2) return _buildCollectionsRow();
    if (index == 3)
      return Container(
          padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
          child: Text("Posts",
              style: Theme.of(context).textTheme.headline6));
    return _buildListItem();
  }

  Widget _buildListItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: PNetworkImage(
            "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media",
            fit: BoxFit.cover),
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

  Container _buildCollectionsRow() {
    return Container(
      height: 200.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: collections.length,
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
                    child: PNetworkImage(collections[index]['image'],
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  collections[index]['title'],
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          );
        },
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