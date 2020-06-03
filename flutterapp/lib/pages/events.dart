import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterapp/pages/event_details.dart';

final List events = [
  {
    "image":
        "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media",
    "title": "Evento 1"
  },
  {
    "image":
        "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media",
    "title": "Evento 2"
  },
  {
    "image":
        "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media",
    "title": "Evento 3"
  },
  {
    "image":
        "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media",
    "title": "Evento 4"
  },
];
class EventsPage extends StatefulWidget {
  @override
  _EventsPagePageState createState() => _EventsPagePageState();
}

class _EventsPagePageState extends State<EventsPage> {

  TextEditingController controller;


  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
              return _buildEvents(context, index);
            }, childCount: 10),
          )
        ],
      ),
    );
  }

  Widget _buildEvents(BuildContext context, int index) {
    var event = events[index % events.length];
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
                      Image(image: CachedNetworkImageProvider(event['image'])),
                      Positioned(
                        bottom: 20.0,
                        right: 10.0,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          color: Theme.of(context).cardColor,
                          child: Text("Gratis"),
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
                          event['title'],
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
