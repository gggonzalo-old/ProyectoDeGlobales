import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/pages/create_post.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/view_models/home_model.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/widgets/home_posts_list_widget.dart';
import 'package:google_fonts/google_fonts.dart';
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
            'World Hope',
            textAlign: TextAlign.center,
            style: GoogleFonts.justAnotherHand(fontSize: 38),
          ),
          Row(
            children: <Widget>[
              Container(
                width: 35.0,
                child: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  iconSize: 30.0,
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePostPage.create(context),
                      ),
                    )
                  },
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
        : model.posts.isNotEmpty
            ? HomePostList(
                model: model,
              )
            : Container(
                height: 500,
                child: Center(
                  child: Text("Not posts found add friends"),
                ),
              );
  }
}
