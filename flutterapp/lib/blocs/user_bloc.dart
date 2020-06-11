import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {/*
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
            photoUrl: "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fphotographer.jpg?alt=media"
          ),
        )
        .toList(growable: false);
  }*/
}
