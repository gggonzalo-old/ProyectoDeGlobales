import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/pages/event_details.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/view_models/event_model.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  EventsPage({Key key, @required this.eventModel}) : super(key: key);
  final EventModel eventModel;
  static Widget create(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authenticaion =
        Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<EventModel>(
      create: (_) =>
          EventModel(authentication: authenticaion, dataService: dataService),
      child: Consumer<EventModel>(
        builder: (context, model, _) => EventsPage(
          eventModel: model,
        ),
      ),
    );
  }

  @override
  _EventsPagePageState createState() => _EventsPagePageState();
}

class _EventsPagePageState extends State<EventsPage> {
  EventModel get model => widget.eventModel;

  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.updateData();
    });
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: model.updateData,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: Icon(Icons.search),
              title: TextField(
                controller: controller,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
              ),
            ),
            /*SliverToBoxAdapter(
              child: _buildCategories(),
            ),*/
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return _buildEvents(context, model.events[index]);
              }, childCount: model.events.length),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEvents(BuildContext context, Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDetailsPage()),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(5.0),
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image(image: CachedNetworkImageProvider(event.imageUrl)),
                      Positioned(
                        bottom: 20.0,
                        right: 10.0,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          color: Theme.of(context).cardColor,
                          child: Text(event.price.toString()),
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          event.name,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text("Heredia, Costa Rica"),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
