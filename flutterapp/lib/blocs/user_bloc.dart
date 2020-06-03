  
import 'package:flutterapp/data_models/user.dart';
import 'package:flutterapp/providers/users_provider.dart';
import 'package:flutterapp/view_models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class UserBLoC {
  final userList = BehaviorSubject<List<UserModel>>();
  final UserProvider user;

  UserBLoC({
    @required this.user,
  }) {
    getUsers()
        .then(toViewModel)
        .then(userList.add)
        .catchError((err) => print('Error getting repo $err'));
  }

  Future<List<User>> getUsers() {
    return user.getUsers();
  }

  List<UserModel> toViewModel(List<User> dataModelList) {
    return dataModelList
        .map(
          (dataModel) =>
          UserModel(
            id: dataModel.id,
            name: dataModel.name,
            username: dataModel.username,
          ),
    )
        .toList(growable: false);
  }

  void dispose() {
    userList.close();
  }
}