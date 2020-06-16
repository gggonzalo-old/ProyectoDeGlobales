import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

class EventDetailModel with ChangeNotifier {
  EventDetailModel({
    @required this.authentication,
    @required this.dataService,
    this.event,
    this.isLoading = true,
  });

  final AuthenticationBase authentication;
  final DataService dataService;
  Event event;
  bool isLoading;
  bool requested;

  Future<void> updateEvent() async {
    try {
      updateWith(isLoading: true);
      User user = await authentication.currentUser();
      Event event = await dataService.getEvent(user, this.event);
      updateWith(event: event);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  Future<void> enrollOnEvent() async {
    try {
      updateWith(isLoading: true);
      User user = await authentication.currentUser();
      Event updatedEvent = await dataService.toggleEventEnrollment(user, this.event);
      updateEventWith(updatedEvent);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateWith({bool isLoading, Event event}) {
    this.event = event ?? this.event;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }

  void updateEventWith(Event event) {
    this.event = event;
    notifyListeners();
  }
}
