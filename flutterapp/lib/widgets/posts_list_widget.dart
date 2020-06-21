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
      if (model.posts.isEmpty) {
        return Scaffold(
          body: Center(
            child: Text("Not posts found"),
          ),
        );
      } else {
        return Scaffold(
          body: ListView(
            children: <Widget>[
              _buildEventOrganizerInformation(context),
              _buildSearchPosts(context)
            ],
          ),
        );
      }
    }
  }

  Widget _buildEventOrganizerInformation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(
                            model.event.owner.imageUrl),
                      ),
                      border: Border.all(
                          width: 3,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(model.event.imageUrl),
                      ),
                      border: Border.all(
                          width: 3,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Flexible(
                  child: Center(
                    child: Text(
                      model.event.owner.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: Center(
                    child: Text(
                      model.event.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          /*Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(
                            model.event.owner.imageUrl),
                      ),
                      border: Border.all(
                          width: 3,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  model.event.owner.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(
                          model.event.imageUrl,
                        ),
                      ),
                      border: Border.all(
                        width: 3,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(model.event.name +
                    "eraereraereraereraereraereraereraereraereraereraereraereraereraereraereraereraereraereraereraereraereraereraereraereraer")
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildSearchPosts(BuildContext context) {
    return StaggeredGridView.countBuilder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
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
