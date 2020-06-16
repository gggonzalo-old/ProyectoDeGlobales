import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

class EventModel with ChangeNotifier {
  EventModel(
      {@required this.authentication,
      @required this.dataService,
      this.events,
      this.isLoading = true});

  final AuthenticationBase authentication;
  final DataService dataService;
  List<Event> events;
  bool isLoading;

  Future<void> updateData() async {
    try {
      updateWith(isLoading: true);
      List<Event> events = await dataService.getEvents("");
      updateWith(events: events);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  Future<void> toggleLike(Event event) async {
    try {
      User user = await authentication.currentUser();
      /*Event updatedEvent = await dataService.toggleLikePost(user, post);*/
      updateHomePostWith(/*updatedEvent*/ Event());
    } catch (e) {
      rethrow;
    }
  }

  void updateWith({List<Event> events, bool isLoading}) {
    this.events = events ?? this.events;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }

  void updateHomePostWith(Event event) {
    for (Event event in events) {
      if (event.id == event.id) {
        event = event;
      }
    }
    notifyListeners();
  }
}
