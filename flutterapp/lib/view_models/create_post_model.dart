import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/authentication.dart';
import 'package:flutterapp/services/data.dart';
import 'package:provider/provider.dart';

class CreatePostModel with ChangeNotifier {
  CreatePostModel(
      {@required this.authentication,
      @required this.dataService,
      this.image,
      this.dropdownValue,
      this.description,
      this.isLoading = true,
      this.userTags = const []});

  final AuthenticationBase authentication;
  final DataService dataService;
  String dropdownValue;
  String description;
  bool isLoading;
  File image;
  List<String> userTags;

  Future<void> createPost() async {
    try {
      updateWith(isLoading: true);
      final FirebaseStorage storage =
          FirebaseStorage(storageBucket: "gs://worldhope-f4a14.appspot.com");
      StorageUploadTask uploadTask;
      String filePath = 'images/${DateTime.now()}.png';
      uploadTask = storage.ref().child(filePath).putFile(image);
      var storageTaskSnapshot = await uploadTask.onComplete;
      var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      Post post = Post(imageUrl: downloadUrl, eventTag: this.dropdownValue, description: this.description);
      User user = await authentication.currentUser();
      await dataService.createPost(user, post);
      await updateData();
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  Future<void> updateData() async {
    try {
      updateWith(isLoading: true);
      User user = await authentication.currentUser();
      User userWithTags = await dataService.getUserTags(user);
      List<String> userTags = userWithTags.eventTags;
      String dropdownValue = userTags.isEmpty ? "" : userTags[0];
      this.image =  null;
      updateWith(userTags: userTags, dropdownValue: dropdownValue);
    } catch (e) {
      print(e);
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateDescription(String description) {
    this.description = description;
  }

  void selectImage(File image) {
    updateWith(image: image);
  }

  void updateDropDownValue(String dropdownValue) {
    updateWith(dropdownValue: dropdownValue);
  }

  void updateWith(
      {bool isLoading,
      File image,
      String dropdownValue,
      String description,
      List<String> userTags}) {
    this.isLoading = isLoading ?? this.isLoading;
    this.image = image ?? this.image;
    this.dropdownValue = dropdownValue ?? this.dropdownValue;
    this.description = description ?? this.description;
    this.userTags = userTags ?? this.userTags;
    notifyListeners();
  }
}
