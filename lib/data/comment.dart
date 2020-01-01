
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/constants/firebase_keys.dart';

class CommentModel {
  final String comment;
  final String commentKey;
  final String userKey;
  final String username;
  final DateTime commentTime;
  final DocumentReference reference;

  CommentModel.fromMap(Map<String, dynamic> map, this.commentKey, { this.reference })
  : this.comment = map[KEY_COMMENT],
  this.userKey = map[KEY_USERKEY],
  this.username = map[KEY_USERNAME],
  this.commentTime = (map[KEY_COMMENTTIME] as Timestamp).toDate();

  CommentModel.fromSnapshot(DocumentSnapshot snapshot)
  : this.fromMap(snapshot.data, snapshot.documentID, reference: snapshot.reference);

  static Map<String, dynamic> getMapForNewComment(String userKey, String username, String comment) {

    Map<String, dynamic> map = Map();

    map[KEY_USERKEY] = userKey;
    map[KEY_USERNAME] = username;
    map[KEY_COMMENT] = comment;
    map[KEY_COMMENTTIME] = DateTime.now().toUtc();

    return map;
  }

}