import 'package:flutter/material.dart';
import 'package:flutterapp/pages/create_post.dart';
import 'package:flutterapp/pages/home.dart';
import 'package:flutterapp/pages/profile.dart';
import 'package:flutterapp/pages/search.dart';
import 'package:flutterapp/pages/events.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigation createState() => _BottomNavigation();
}

class _BottomNavigation extends State<BottomNavigation> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = [];
  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static void _createSubPages(BuildContext context) {
    if (_widgetOptions.length != 5) {
      _widgetOptions.add(HomePage.create(context));
      _widgetOptions.add(SearchPage.create(context));
      _widgetOptions.add(CreatePostPage.create(context));
      _widgetOptions.add(EventsPage.create(context));
      _widgetOptions.add(ProfilePage.create(context, user: null));
    }
  }

  @override
  Widget build(BuildContext context) {
    _createSubPages(context);
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_photo_alternate,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text('Add post'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text('Events'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text('Account'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
      ),
    );
  }
}
