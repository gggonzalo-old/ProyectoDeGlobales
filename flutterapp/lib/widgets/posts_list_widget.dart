import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterapp/pages/post_details.dart';
import 'package:flutterapp/view_models/search_model.dart';

class PostsList extends StatefulWidget {
  PostsList({Key key, @required this.model}) : super(key: key);
  final SearchModel model;

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
  ];

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
      if (model.posts.length == 0) {
        return Scaffold(
          body: Center(
            child: Text("Not posts found"),
          ),
        );
      } else {
        return _buildSearchPosts(context);
      }
    }
  }

  Widget _buildSearchPosts(BuildContext context) {
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 3,
      itemCount: model.posts.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostDetailsPage.create(
                context,
                model.posts[index],
              ),
            ),
          )
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(model.posts[index].imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
      staggeredTileBuilder: (index) => _staggeredTiles[index % 10],
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}
