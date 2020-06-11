import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/view_models/home_model.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/widgets/home_posts_list_widget.dart';
import 'package:provider/provider.dart';

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;
  const StatefulWrapper({@required this.onInit, @required this.child});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, @required this.homeModel}) : super(key: key);
  final HomeModel homeModel;
  static Widget create(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authenticaion =
        Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<HomeModel>(
      create: (_) =>
          HomeModel(authentication: authenticaion, dataService: dataService),
      child: Consumer<HomeModel>(
        builder: (context, model, _) => HomePage(
          homeModel: model,
        ),
      ),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeModel get model => widget.homeModel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: model.homePosts,
      future: Provider.of<DataService>(context)
          .getHomePosts(User())
          .then((posts) => model.updateWith(homePosts: posts)),
      builder: (context, snapshot) {
        if (model.homePosts.length == 0) {
          return Scaffold(
            body: Center(
              child: Text("Not posts found add friends"),
            ),
          );
        } else {
          if (model.homePosts.length > 0) {
            return _buildHome(context);
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildHome(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'WorldHope',
                style: TextStyle(
                  fontFamily: 'Billabong',
                  fontSize: 32.0,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 35.0,
                    child: IconButton(
                      icon: Icon(Icons.send),
                      iconSize: 30.0,
                      onPressed: () => print('Direct Messages'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        HomePostList(
          model: model,
        )
      ],
    );
  }
}

/*Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          'Events',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),*/
/*Container(
                  width: double.infinity,
                  height: 100.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: stories.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return SizedBox(width: 10.0);
                      }
                      return Container(
                        margin: EdgeInsets.all(10.0),
                        width: 60.0,
                        height: 60.0,
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
                              height: 60.0,
                              width: 60.0,
                              image: CachedNetworkImageProvider(stories[index - 1]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),*/
