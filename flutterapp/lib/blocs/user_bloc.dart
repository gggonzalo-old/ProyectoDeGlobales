import 'dart:async';

import 'package:flutterapp/data_models/user.dart';
import 'package:flutterapp/providers/users_provider.dart';
import 'package:flutterapp/view_models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;
  void dispose() {
    _isLoadingController.close();

    userList.close();
  }

  void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);
  final userList = BehaviorSubject<List<UserModel>>();
  final UserProvider provider;

  UserBloc({
    this.provider,
  }) {
    getUsers()
        .then(toViewModel)
        .then(userList.add)
        .catchError((err) => print('Error getting repo $err'));
  }

  Future<List<User>> getUsers() {
    return provider.getUsers();
  }

  List<UserModel> toViewModel(List<User> dataModelList) {
    return dataModelList
        .map(
          (dataModel) => UserModel(
            id: dataModel.id,
            name: dataModel.name,
            username: dataModel.username,
          ),
        )
        .toList(growable: false);
  }
}
