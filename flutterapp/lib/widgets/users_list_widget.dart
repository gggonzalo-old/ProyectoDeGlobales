import 'package:flutter/material.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/pages/profile.dart';
import 'package:flutterapp/view_models/search_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UsersList extends StatefulWidget {
  UsersList({Key key, @required this.model}) : super(key: key);
  final SearchModel model;

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UsersList> {
  SearchModel get model => widget.model;
  @override
  Widget build(BuildContext context) {
    if (model.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (model.users.length == 0) {
        return Scaffold(
          body: Center(
            child: Text("Not users found."),
          ),
        );
      } else {
        return ListView.builder(
          itemCount: model.users.length,
          itemBuilder: (context, index) {
            return _buildItemProfile(context, model.users[index]);
          },
        );
      }
    }
  }

  Row _buildItemProfile(BuildContext context, User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage.create(context, user: user),
                ),
              )
            },
            child: Material(
              elevation: 5.0,
              shape: CircleBorder(),
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
            ),
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.username,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(user.name)
                  ],
                ),
              ),
              user.isFriend
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.only(top: 2.0),
                        child: FlatButton(
                          onPressed: () => {model.addFriend(user)},
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 27.0,
                            child: Text(
                              "Add",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: user.isFriend ? Colors.white : Colors.blue,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        )
      ],
    );
  }
}
