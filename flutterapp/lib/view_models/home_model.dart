import 'package:flutter/foundation.dart';
import 'package:flutterapp/models/homeposts.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';

class HomeModel with ChangeNotifier {
  HomeModel(
      {@required this.authentication,
      @required this.dataService,
      List<HomePost> homePosts,
      this.isLoading = false,
      this.requested = false})
      : homePosts = homePosts ?? List<HomePost>();

  final AuthenticationBase authentication;
  final DataService dataService;
  List<HomePost> homePosts;
  bool isLoading;
  bool requested;

  void updateWith({List<HomePost> homePosts, bool isLoading, bool requested}) {
    this.homePosts = homePosts ?? this.homePosts;
    this.isLoading = isLoading ?? this.isLoading;
    this.requested = requested ?? this.requested;
    notifyListeners();
  }
}
