import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterapp/models/comment.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/pages/search.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/view_models/post_detail_model.dart';
import 'package:provider/provider.dart';

class PostDetailsPage extends StatefulWidget {
  PostDetailsPage({@required this.postDetailModel});
  final PostDetailModel postDetailModel;

  static Widget create(BuildContext context, Post post) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authentication =
        Provider.of<AuthenticationBase>(context, listen: false);
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
                                _buildHeaderPost(context),
                                _buildPostImage(context),
                                _buildIcons(),
                                model.post.description == "null"
                                    ? SizedBox()
                                    : _buildDescription(context),
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
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _buildPostComment(context),
    );
  }

  Widget _buildHeaderPost(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 30.0,
          onPressed: () => Navigator.pop(context, model.post),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
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
                    image: CachedNetworkImageProvider(post.owner.photoUrl),
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
    );
  }

  Widget _buildPostImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          InkWell(
            onDoubleTap: () => model.toggleLike(),
            child: Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.black54,
                  Colors.black12,
                ],
              ),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchPage.create(context,
                        eventTag: model.post.eventTag),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    model.post.isVerified
                        ? Icon(Icons.verified_user)
                        : SizedBox(),
                    Text(
                      "#${post.eventTag}",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .merge(TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcons() {
    return Padding(
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
                          onPressed: () => {model.toggleLike()},
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
          model.isLoadingBookMarked
              ? CircularProgressIndicator()
              : IconButton(
                  icon: Icon(post.isBookMarked
                      ? Icons.bookmark
                      : Icons.bookmark_border),
                  iconSize: 30.0,
                  color: post.isBookMarked ? Colors.blue : null,
                  onPressed: () => {model.toggleBookmark()},
                ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Description",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 6),
                Text(
                  model.post.description,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(Comment comment) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.0),
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
                image: CachedNetworkImageProvider(comment.user.photoUrl),
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
    return Transform.translate(
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
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            controller: model.commentController,
            onChanged: model.updateComment,
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
                    future:
                        Provider.of<AuthenticationBase>(context).currentUser(),
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
                  onPressed: model.isLoading ? null : model.createComment,
                  child: Icon(
                    Icons.send,
                    size: 25.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
