import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterapp/blocs/user_bloc.dart';
import 'package:flutterapp/providers/users_provider.dart';
import 'package:flutterapp/ui/user_widget.dart';
import 'package:provider/provider.dart';

class SearchGalleryPage extends StatefulWidget {
  @override
  _SearchGalleryPageState createState() => _SearchGalleryPageState();
}

class _SearchGalleryPageState extends State<SearchGalleryPage> {
  final List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 1),
  ];

  /*


  BUSCAR FLAPPY SEARCH BAR


  */

  TextEditingController controller;

  void changeFollowStatus() {}

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.search),
          title: TextField(
            controller: controller,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.photo_library)),
            Tab(icon: Icon(Icons.person)),
          ]),
        ),
        body: TabBarView(
          children: [
            _buildSearchPosts(context),
            Provider<UserBLoC>(
              dispose: (_, bloc) => bloc.dispose(),
              create: (BuildContext context) {
                return UserBLoC(
                  user: UserProvider(),
                );
              },
              child: UserWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchPosts(BuildContext context) {
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 3,
      itemCount: 16,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                  'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10.0)),
      ),
      staggeredTileBuilder: (index) => _staggeredTiles[index],
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}
