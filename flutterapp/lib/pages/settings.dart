import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterapp/providers/theme_provider.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/models/user.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  String switchThemeText = "Off";

  @override
  void initState() {
    super.initState();
    final themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    isDarkMode = ThemeData.light() == themeChanger.getTheme() ? false : true;
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final authentication =
          Provider.of<AuthenticationBase>(context, listen: false);
      await authentication.signOut();
      Navigator.of(context).pop();
    } catch (e) {
      e.toString();
    }
  }

  Future<void> _toggleTheme(BuildContext context) async {
    try {
      final themeChanger = Provider.of<ThemeChanger>(context, listen: false);
      if (ThemeData.light() == themeChanger.getTheme()) {
        await themeChanger.setTheme(ThemeData.dark());
        setState(() {
          switchThemeText = "On";
          isDarkMode = true;
        });
      } else {
        await themeChanger.setTheme(ThemeData.light());
        setState(() {
          switchThemeText = "Off";
          isDarkMode = false;
        });
      }
    } catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authentication =
        Provider.of<AuthenticationBase>(context, listen: false);
    return FutureBuilder<User>(
      future: authentication.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            User user = snapshot.data;
            return _buildSettings(context, user);
          }
        }
      },
    );
  }

  Widget _buildSettings(BuildContext context, User user) {
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
                      image: CachedNetworkImageProvider(user.photoUrl),
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
              subtitle: Text(switchThemeText),
              value: isDarkMode,
              onChanged: (value) => {_toggleTheme(context)},
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
