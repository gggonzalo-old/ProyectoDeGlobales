import 'package:flutter/material.dart';
import 'package:flutterapp/models/homeposts.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/pages/post_details.dart';
import 'package:flutterapp/view_models/home_model.dart';
import 'package:flutterapp/view_models/search_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePostList extends StatefulWidget {
  HomePostList({Key key, @required this.model}) : super(key: key);
  final HomeModel model;

  @override
  _HomePostListState createState() => _HomePostListState();
}

class _HomePostListState extends State<HomePostList> {
  HomeModel get model => widget.model;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: model.homePosts.length,
      itemBuilder: (context, index) {
        return _buildPost(context, model.homePosts[index]);
      },
    );
  }

  Widget _buildPost(BuildContext context, HomePost homePost) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: double.infinity,
        height: 560,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image(
                            height: 50.0,
                            width: 50.0,
                            image: CachedNetworkImageProvider(
                                homePost.user.photoUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      homePost.user.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(homePost.post.date),
                    trailing: IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () => print('More'),
                    ),
                  ),
                  InkWell(
                    onDoubleTap: () => print('Like post'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailsPage.create(
                            context,
                            homePost,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      width: double.infinity,
                      height: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 5),
                            blurRadius: 8.0,
                          ),
                        ],
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              homePost.post.imageUrl),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(homePost.post.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border),
                                  iconSize: 30.0,
                                  color:
                                      homePost.post.isLiked ? Colors.red : null,
                                  onPressed: () =>
                                      {model.toggleLike(homePost.post)},
                                ),
                                Text(
                                  homePost.post.usersWhoLiked.length.toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20.0),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.chat),
                                  iconSize: 30.0,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PostDetailsPage.create(
                                          context,
                                          homePost,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  homePost.post.comments.length.toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.bookmark_border),
                          iconSize: 30.0,
                          onPressed: () => print('Save post'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
