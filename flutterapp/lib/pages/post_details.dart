import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterapp/models/comment.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/view_models/post_detail_model.dart';
import 'package:provider/provider.dart';

class PostDetailsPage extends StatefulWidget {
  PostDetailsPage({@required this.postDetailModel});
  final PostDetailModel postDetailModel;

  static Widget create(BuildContext context, Post post) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authentication = Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<PostDetailModel>(
      create: (_) => PostDetailModel(
          dataService: dataService, authentication: authentication, post: post),
      child: Consumer<PostDetailModel>(
        builder: (context, model, _) => PostDetailsPage(
          postDetailModel: model,
        ),
      ),
    );
  }

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  PostDetailModel get model => widget.postDetailModel;
  Post get post => widget.postDetailModel.post;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.updatePost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: model.updatePost,
        child: model.isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      iconSize: 30.0,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: ListTile(
                                        leading: Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black45,
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
                                                image:
                                                    CachedNetworkImageProvider(
                                                        post.owner.photoUrl),
                                                fit: BoxFit.cover,
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
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onDoubleTap: () => print('Like post'),
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    width: double.infinity,
                                    height: 400.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0, 5),
                                          blurRadius: 8.0,
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            post.imageUrl),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(post.isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border),
                                                iconSize: 30.0,
                                                color: post.isLiked
                                                    ? Colors.red
                                                    : null,
                                                onPressed: () =>
                                                    {model.toggleLike()},
                                              ),
                                              Text(
                                                post.usersWhoLiked.length
                                                    .toString(),
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
                                                  print('Chat');
                                                },
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
                    SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: post.comments.length,
                              itemBuilder: (context, index) {
                                return _buildComment(post.comments[index]);
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -2),
                blurRadius: 6.0,
              ),
            ],
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: _buildPostComment(context),
        ),
      ),
    );
  }

  Widget _buildComment(Comment comment) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
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
                    comment.user.photoUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
         comment.user.username,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(comment.content),
        /*trailing: IconButton(
          icon: Icon(
            Icons.favorite_border,
          ),
          color: Colors.grey,
          onPressed: () => print('Like comment'),
        ),*/
      ),
    );
  }

  Widget _buildPostComment(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          contentPadding: EdgeInsets.all(20.0),
          hintText: 'Add a comment',
          prefixIcon: Container(
            margin: EdgeInsets.all(4.0),
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0, 2),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: FutureBuilder<User>(
                future: Provider.of<AuthenticationBase>(context).currentUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CircleAvatar(
                      child: ClipOval(
                        child: Image(
                          height: 48.0,
                          width: 48.0,
                          image: CachedNetworkImageProvider(
                              snapshot.data.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    return CircleAvatar(
                      child: ClipOval(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }),
          ),
          suffixIcon: Container(
            margin: EdgeInsets.only(right: 4.0),
            width: 70.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Theme.of(context).buttonColor,
              onPressed: () => {model.createComment("hola")},
              child: Icon(
                Icons.send,
                size: 25.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
