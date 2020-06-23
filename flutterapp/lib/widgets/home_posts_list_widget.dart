import 'package:flutter/material.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/pages/post_details.dart';
import 'package:flutterapp/pages/profile.dart';
import 'package:flutterapp/view_models/home_model.dart';
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
      itemCount: model.posts.length,
      itemBuilder: (context, index) {
        return _buildPost(context, model.posts[index]);
      },
    );
  }

  Widget _buildPost(BuildContext context, Post post) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: double.infinity,
        height: 500,
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
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage.create(context, user: post.owner),
                            ),
                          )
                        },
                        child: CircleAvatar(
                          child: ClipOval(
                            child: Image(
                              height: 50.0,
                              width: 50.0,
                              image: CachedNetworkImageProvider(
                                  post.owner.photoUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      post.owner.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(post.date),
                    trailing: IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () => print('More'),
                    ),
                  ),
                  InkWell(
                    onDoubleTap: () => print('Like post'),
                    onTap: () async {
                      Post updatedPost = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailsPage.create(
                            context,
                            post,
                          ),
                        ),
                      );
                      model.updatePost(updatedPost);
                    },
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      width: double.infinity,
                      height: 340.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 5),
                            blurRadius: 8.0,
                          ),
                        ],
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(post.imageUrl),
                          fit: BoxFit.fill,
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
                                model.isLoadingLike
                                    ? CircularProgressIndicator()
                                    : IconButton(
                                        icon: Icon(post.isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border),
                                        iconSize: 30.0,
                                        color: post.isLiked ? Colors.red : null,
                                        onPressed: () =>
                                            {model.toggleLike(post)},
                                      ),
                                Text(
                                  post.usersWhoLiked.length.toString(),
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
                                  onPressed: () {},
                                ),
                                Text(
                                  post.comments.length.toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        model.isLoadingBookMarked
                            ? CircularProgressIndicator()
                            : IconButton(
                                icon: Icon(post.isBookMarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border),
                                iconSize: 30.0,
                                color: post.isBookMarked ? Colors.blue : null,
                                onPressed: () => {model.toggleBookmark(post)},
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
