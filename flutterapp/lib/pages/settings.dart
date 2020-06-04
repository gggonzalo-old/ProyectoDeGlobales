import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/view_models/user_model.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final authentication = Provider.of<AuthenticationBase>(context, listen: false);
      await authentication.signOut();
    } catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authentication = Provider.of<AuthenticationBase>(context, listen: false);
    return FutureBuilder<UserModel>(
      future: authentication.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            UserModel user = snapshot.data;
            return _buildSettings(context, user);
          }
        }
      },
    );
  }

  Widget _buildSettings(BuildContext context, UserModel user) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media"),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        user.username,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ListTile(
              title: Text(
                "Languages", /*style: whiteBoldText,*/
              ),
              subtitle: Text("English US"),
              trailing: Icon(
                Icons.keyboard_arrow_right,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "Profile Settings", /*style: whiteBoldText,*/
              ),
              subtitle: Text(user.name),
              trailing: Icon(
                Icons.keyboard_arrow_right,
              ),
              onTap: () {},
            ),
            SwitchListTile(
              title: Text(
                "Dark mode", /*style: whiteBoldText,*/
              ),
              subtitle: Text("Off"),
              value: false,
              onChanged: (val) {},
            ),
            ListTile(
              title: Text(
                "Logout", /*style: whiteBoldText,*/
              ),
              onTap: () {
                _signOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
