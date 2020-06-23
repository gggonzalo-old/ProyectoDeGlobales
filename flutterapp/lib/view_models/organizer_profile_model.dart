import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/organizer.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

class OrganizerProfileModel with ChangeNotifier {
  OrganizerProfileModel({
    @required this.authentication,
    @required this.dataService,
    this.organizer,
    this.isLoading = true,
  });

  final AuthenticationBase authentication;
  final DataService dataService;
  Organizer organizer;
  bool isLoading;

  Future<void> updateData() async {
    try {
      updateWith(isLoading: true);
      Organizer organizer = await dataService.getOrganizer(this.organizer);
      updateWith(organizer: organizer);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateWith({
    Organizer organizer,
    bool isLoading,
  }) {
    this.organizer = organizer ?? this.organizer;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }
}
