import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/constants/firebase_keys.dart';

class User {
  final String userKey;
  final String profileImg;
  final String userName;
  final String email;
  final int followers;
  final List<dynamic> followings;
  final List<dynamic> likedPosts;
  final List<dynamic> myPosts;
  final DocumentReference refenence;

  User.fromMap(Map<String, dynamic> map, this.userKey, {this.refenence})
      : profileImg = ' ',
        userName = map[KEY_USERNAME],
        email = map[KEY_EMAIL],
        likedPosts = map[KEY_LIKEDPOSTS],
        followers = map[KEY_FOLLOWERS],
        followings = map[KEY_FOLLOWINGS],
        myPosts = map[KEY_MYPOSTS];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.documentID,
            refenence: snapshot.reference);

  static Map<String, dynamic> getMapForCreateUser(String email) {
    Map<String, dynamic> map = Map();
    map[KEY_PROFILEIMG] = ' ';
    map[KEY_USERNAME] = email.split('@')[0];
    map[KEY_EMAIL] = email;
    map[KEY_LIKEDPOSTS] = [];
    map[KEY_FOLLOWERS] = 0;
    map[KEY_FOLLOWINGS] = [];
    map[KEY_MYPOSTS] = [];

    return map;
  }
}
