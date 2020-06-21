import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/view_models/home_model.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/widgets/home_posts_list_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, @required this.homeModel}) : super(key: key);
  final HomeModel homeModel;
  static Widget create(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authenticaion =
        Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<HomeModel>.value(
      value: HomeModel(authentication: authenticaion, dataService: dataService),
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.updateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: model.updateData,
      child: Scaffold(
        body: ListView(children: <Widget>[
          _buildHome(context),
          _buildContent(context),
        ]),
      ),
    );
  }

  Widget _buildHome(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'WorldHope',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 32.0,
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                width: 35.0,
                child: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  iconSize: 30.0,
                  onPressed: () => print('Direct Messages'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return model.isLoading
        ? Container(
            height: MediaQuery.of(context).size.height -
                (MediaQuery.of(context).padding.bottom +
                    MediaQuery.of(context).padding.top),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : model.posts.length > 0
            ? HomePostList(
                model: model,
              )
            : Align(
                alignment: Alignment.center,
                child: Center(
                  child: Text("Not posts found add friends"),
                ),
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
