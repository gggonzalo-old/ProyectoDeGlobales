import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/prize.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

enum EventSearchType { event, prize }

class EventModel with ChangeNotifier {
  EventModel({
    @required this.authentication,
    @required this.dataService,
    this.events = const [],
    this.prizes = const [],
    this.prizeClaimedSuccess,
    this.isLoading = true,
    this.search = "",
  });

  TextEditingController searchController = TextEditingController();
  final AuthenticationBase authentication;
  final DataService dataService;
  String search;
  List<Event> events;
  List<Prize> prizes;
  bool prizeClaimedSuccess;
  bool isLoading;
  EventSearchType searchType;

  Future<void> updateData() async {
    try {
      updateWith(isLoading: true);
      List<Event> events = await dataService.getEvents(search);
      List<Prize> prizes = await dataService.getPrizes(search);
      updateWith(events: events, prizes: prizes);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void toggleSearchType(EventSearchType eventSearchType) {
    updateWith(
        events: const [],
        prizes: const [],
        searchType: searchType,
        isLoading: false);
  }

  Future<void> claimPrize(Prize prize) async {
    try {
      User user = await authentication.currentUser();
      bool prizeClaimedSuccess = await dataService.claimPrize(user, prize);
      updateWith(prizeClaimedSuccess: prizeClaimedSuccess);
    } catch (e) {
      print(e);
    }
  }

  void updateSearch(String search) async {
    updateWith(search: search);
    await updateData();
  }

  void updateWith(
      {List<Event> events,
      List<Prize> prizes,
      bool prizeClaimedSuccess,
      bool isLoading,
      String search,
      EventSearchType searchType}) {
    this.prizes = prizes ?? this.prizes;
    this.events = events ?? this.events;
    this.prizeClaimedSuccess = prizeClaimedSuccess ?? this.prizeClaimedSuccess;
    this.isLoading = isLoading ?? this.isLoading;
    this.search = search ?? this.search;
    this.searchType = searchType ?? this.searchType;
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
