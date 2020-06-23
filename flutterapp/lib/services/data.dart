import 'package:flutterapp/models/event.dart';
import 'package:flutterapp/models/organizer.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/models/prize.dart';
import 'package:flutterapp/models/user.dart';

abstract class DataService {
  Future<User> getUser(User currentUser, User user);
  Future<User> getUserTags(User user);
  Future<User> getUserBookMarkedsPosts(User user);
  Future<Event> getEvent(User user, Event event);
  Future<Post> getPost(User user, Post post);
  Future<Organizer> getOrganizer(Organizer organizer);
  Future<List<User>> getUsers(User user, String search);
  Future<List<Post>> getPostsByHashTag(String search);
  Future<List<Post>> getHomePosts(User user);
  Future<List<Event>> getEvents(String search);
  Future<List<Prize>> getPrizes(String search);
  Future<void> createUser(User user);
  Future<void> createPost(User user, Post post);
  Future<void> createCommentPost(Post post, User user, String comment);
  Future<Post> toggleLikePost(User user, Post post);
  Future<Post> toggleUserPostBookmark(User user, Post post);
  Future<Event> toggleEventEnrollment(User user, Event event);
  Future<Event> toggleEventInInterested(User user, Event event);
  Future<bool> claimPrize(User user, Prize prize);
  Future<void> addFriend(User user, User friend);
  Future<void> removeFriend(User user, User friend);
}
