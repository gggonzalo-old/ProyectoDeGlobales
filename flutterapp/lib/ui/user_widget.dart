import 'package:flutter/material.dart';
import 'package:flutterapp/blocs/user_bloc.dart';
import 'package:flutterapp/view_models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserWidget extends StatelessWidget {
  static Widget create(BuildContext context) {
    return Provider<UserBloc>(
      create: (_) => UserBloc(),
      child: UserWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<UserBloc>(context);
    return StreamBuilder(
      stream: bloc.userList,
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final list = userSnapshot.data as List<UserModel>;

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _buildItemProfile(context, list[index]);
          },
        );
      },
    );
  }

  Row _buildItemProfile(BuildContext context, UserModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 5.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: CachedNetworkImageProvider(
                  "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media"),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(top: 2.0),
                  child: FlatButton(
                    onPressed: () => {},
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: 27.0,
                      child: Text(
                        "Follow",
                        style: TextStyle(
                          color: true ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: true ? Colors.white : Colors.blue,
                        border: Border.all(
                          color: true ? Colors.grey : Colors.blue,
                        ),
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
