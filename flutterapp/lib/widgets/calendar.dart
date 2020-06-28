import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Junio 2019",
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FloatingActionButton(
                  onPressed: null,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.red,
                ),
              )
            ],
          ),
          body: MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    _buildCalendar(context),
                    _buildEventsList(),
                  ],
                )
              : Column(
                  children: <Widget>[
                    _buildCalendar(context),
                    SizedBox(
                      height: 8,
                    ),
                    _buildEventsList(),
                  ],
                )),
    );
  }

  Flexible _buildCalendar(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: CalendarCarousel<Event>(
          onDayPressed: (DateTime date, List<Event> events) {
            //take an action with date and its events
          },
          firstDayOfWeek: 0,
          showHeader: false,
          isScrollable: true,
          pageScrollPhysics: NeverScrollableScrollPhysics(),
          weekFormat: false,
          daysTextStyle: TextStyle(color: Colors.white),
          selectedDateTime: DateTime(2019, 4, 10),
          weekendTextStyle: TextStyle(color: Colors.white),
          daysHaveCircularBorder: true,
          markedDatesMap: _getCarouselMarkedDates(),
          markedDateWidget: Container(
            height: 4,
            width: 4,
            decoration: new BoxDecoration(
              color: Theme.of(context).accentColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
      ),
    );
  }

  Flexible _buildEventsList() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: 30,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Material(
                      elevation: 5.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: CachedNetworkImageProvider(
                            "https://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: "Event $index example name........",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.business,
                                  size: 16.0,
                                ),
                              ),
                              TextSpan(
                                  text: "Company $index example name",
                                  style: TextStyle(fontSize: 16))
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.schedule,
                                  size: 16.0,
                                ),
                              ),
                              TextSpan(
                                  text: "Jun, 10, 2020 10 a.m. - 4 p.m.",
                                  style: TextStyle(fontSize: 16))
                            ],
                          ),
                        ),
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
                                  text:
                                      "Manuel Antonio National Park, Costa Rica.",
                                  style: TextStyle(fontSize: 16))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.more_vert),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  EventList<Event> _getCarouselMarkedDates() {
    return EventList<Event>(
      events: {
        new DateTime(2019, 4, 3): [
          new Event(
            date: new DateTime(2019, 4, 3),
            title: 'Event 1',
          ),
        ],
        new DateTime(2019, 4, 5): [
          new Event(
            date: new DateTime(2019, 4, 5),
            title: 'Event 1',
          ),
        ],
        new DateTime(2019, 4, 22): [
          new Event(
            date: new DateTime(2019, 4, 22),
            title: 'Event 1',
          ),
        ],
        new DateTime(2019, 4, 24): [
          new Event(
            date: new DateTime(2019, 4, 24),
            title: 'Event 1',
          ),
        ],
        new DateTime(2019, 4, 26): [
          new Event(
            date: new DateTime(2019, 4, 26),
            title: 'Event 1',
          ),
        ],
      },
    );
  }
}
