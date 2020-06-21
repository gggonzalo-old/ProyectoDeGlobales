import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/pages/event_details.dart';
import 'package:flutterapp/view_models/event_model.dart';

class EventList extends StatefulWidget {
  EventList({Key key, @required this.model}) : super(key: key);
  final EventModel model;

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventList> {
  EventModel get model => widget.model;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: model.events.length,
      itemBuilder: (context, index) {
        return _buildEvent(context, model.events[index]);
      },
    );
  }

  Widget _buildEvent(BuildContext context, Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage.create(context, event),
          ),
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
                      Container(
                        child: Image(
                          image: CachedNetworkImageProvider(event.imageUrl),
                          fit: BoxFit.fill,
                        ),
                        height: 300,
                        width: double.infinity,
                      ),
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
                        Text(event.place),
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
