import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:flutterapp/view_models/event_details_model.dart';
import 'package:provider/provider.dart';

enum ButtonType { interested, enroll }

class EventDetailsPage extends StatefulWidget {
  EventDetailsPage({@required this.eventDetailModel});
  final EventDetailModel eventDetailModel;

  static Widget create(BuildContext context, Event event) {
    final dataService = Provider.of<DataService>(context, listen: false);
    final authentication =
        Provider.of<AuthenticationBase>(context, listen: false);
    return ChangeNotifierProvider<EventDetailModel>(
      create: (_) => EventDetailModel(
          dataService: dataService,
          authentication: authentication,
          event: event),
      child: Consumer<EventDetailModel>(
        builder: (context, model, _) => EventDetailsPage(
          eventDetailModel: model,
        ),
      ),
    );
  }

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  EventDetailModel get model => widget.eventDetailModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.updateEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: model.isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                _buildEventPhoto(context),
                _buildPhotoGradient(),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 230),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          model.event.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child:
                                  /*Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20.0)),
                          child:*/
                                  Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.business,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                  SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      model.event.owner.name,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ],
                              ),
                              //),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(32),
                        color: Theme.of(context).cardColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.location_on,
                                                  size: 16.0,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              TextSpan(
                                                text: model.event.place,
                                              )
                                            ],
                                          ),
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        SizedBox(height: 4),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.date_range,
                                                  size: 16.0,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(
                                                text: model.event.date,
                                              )
                                            ],
                                          ),
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          model.event.price.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                        Text(
                                          "i.v.a",
                                          style: TextStyle(fontSize: 14.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        color: Theme.of(context).cardColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 30.0),
                            Text(
                              "Description".toUpperCase(),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              model.event.description,
                              textAlign: TextAlign.justify,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 30.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Interested",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    model.event.usersInterested.length == 0
                                        ? Text("No users found.")
                                        : Container(
                                            height: 50,
                                            child: Stack(
                                              children: [
                                                ...model.event.usersInterested
                                                    .asMap()
                                                    .map(
                                                      (i, e) => MapEntry(
                                                        i,
                                                        Transform.translate(
                                                          offset: Offset(
                                                              i * 25.0, 0),
                                                          child: SizedBox(
                                                              height: 50,
                                                              width: 50,
                                                              child:
                                                                  _buildAvatar(
                                                                      e,
                                                                      radius:
                                                                          25)),
                                                        ),
                                                      ),
                                                    )
                                                    .values
                                                    .toList(),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Enrolled",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    model.event.usersEnrolled.length == 0
                                        ? Row(
                                            children: <Widget>[
                                              Text("No users founds."),
                                            ],
                                          )
                                        : Container(
                                            height: 50,
                                            child: Stack(
                                              children: [
                                                ...model.event.usersEnrolled
                                                    .asMap()
                                                    .map(
                                                      (i, e) => MapEntry(
                                                        i,
                                                        Transform.translate(
                                                          offset: Offset(
                                                              i * 25.0, 0),
                                                          child: SizedBox(
                                                            height: 50,
                                                            width: 50,
                                                            child: _buildAvatar(
                                                                e,
                                                                radius: 25),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .values
                                                    .toList(),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 30.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _buildButton(
                                    context,
                                    ButtonType.interested,
                                    model.event.isInterested
                                        ? "Not longer interested"
                                        : "I'm interested"),
                                SizedBox(width: 20.0),
                                _buildButton(
                                    context,
                                    ButtonType.enroll,
                                    model.event.isEnrolled
                                        ? "Cancel subscription"
                                        : "Enroll on event"),
                              ],
                            ),
                            SizedBox(height: 30)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEventPhoto(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(color: Colors.black26),
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: Image(
        image: CachedNetworkImageProvider(model.event.imageUrl),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPhotoGradient() {
    return Container(
      height: 300.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.0),
            Colors.black.withOpacity(0.6),
          ],
        ),
      ),
    );
  }

  CircleAvatar _buildAvatar(User user, {double radius = 80}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: CircleAvatar(
        radius: radius - 2,
        backgroundImage: CachedNetworkImageProvider(user.photoUrl),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, ButtonType buttonType, String message) {
    Color color;
    if (buttonType == ButtonType.enroll) {
      color = model.event.isEnrolled
          ? Colors.red[500]
          : Theme.of(context).buttonColor;
    } else {
      color = model.event.isInterested
          ? Colors.red[500]
          : Theme.of(context).buttonColor;
    }
    return Expanded(
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: color,
        child: Text(
          message,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: color == Colors.red[500] ? Colors.white : null),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 32.0,
        ),
        onPressed: () => buttonType == ButtonType.enroll
            ? model.enrollOnEvent()
            : model.eventInInterested(),
      ),
    );
  }
}
