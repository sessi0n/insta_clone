import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/constants/firebase_keys.dart';
import 'package:insta_clone/data/comment.dart';
import 'package:insta_clone/data/post.dart';
import 'package:insta_clone/data/user.dart';
import 'package:insta_clone/firebase/transformer.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreProvider with Transformer {
  final Firestore _firestore = Firestore.instance;

  Future<void> attempCreateUser({String userKey, String email}) {
    final DocumentReference userRef =
        _firestore.collection(COLLECTION_USERS).document(userKey);

    return _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot snapshot = await tx.get(userRef);
      if (snapshot.exists) {
        await tx.update(userRef, snapshot.data);
      } else {
        await tx.set(userRef, User.getMapForCreateUser(email));
      }
    });
  }

  Stream<User> connectMyUserData(String userKey) {
    return _firestore
        .collection(COLLECTION_USERS)
        .document(userKey)
        .snapshots()
        .transform(toUser);
  }

  Stream<List<User>> fetchAllUsers() {
    return _firestore
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsers);
  }

  Stream<List<User>> fetchAllUsersExceptMine() {
    return _firestore
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsersExceptMine);
  }

  Future<Map<String, dynamic>> createNewPost(
      String postKey, Map<String, dynamic> postData) async {
    final DocumentReference postRef =
        _firestore.collection(COLLECTION_POSTS).document(postKey);

    final DocumentSnapshot postSanpshot = await postRef.get();

    final DocumentReference userRef =
        _firestore.collection(COLLECTION_USERS).document(postData[KEY_USERKEY]);

    return _firestore.runTransaction((Transaction tx) async {
      await tx.update(userRef, <String, dynamic>{
        KEY_MYPOSTS: FieldValue.arrayUnion([postKey])
      });
      if (!postSanpshot.exists) {
        await tx.set(postRef, postData);
      }
    });
  }

  Future<Map<String, dynamic>> followUser(
      {String myUserKey, String otherUserKey}) async {

    final DocumentReference myUserRef = _firestore.collection(COLLECTION_USERS).document(myUserKey);
    final DocumentSnapshot myUserSnapshot = await myUserRef.get();

    final DocumentReference otherUserRef = _firestore.collection(COLLECTION_USERS).document(otherUserKey);
    final DocumentSnapshot otherUserSnapshot = await otherUserRef.get();

    return _firestore.runTransaction((Transaction tx) async {
      if (myUserSnapshot.exists && otherUserSnapshot.exists) {
        await tx.update(myUserRef, <String, dynamic>{
          KEY_FOLLOWINGS: FieldValue.arrayUnion([otherUserKey])
        });

        int currentFollowers = otherUserSnapshot.data[KEY_FOLLOWERS];
        await tx.update(otherUserRef, <String, dynamic>{
          KEY_FOLLOWERS: currentFollowers+1
        });
      }
    });
  }

  Future<Map<String, dynamic>> unFollowUser(
      {String myUserKey, String otherUserKey}) async {

    final DocumentReference myUserRef = _firestore.collection(COLLECTION_USERS).document(myUserKey);
    final DocumentSnapshot myUserSnapshot = await myUserRef.get();

    final DocumentReference otherUserRef = _firestore.collection(COLLECTION_USERS).document(otherUserKey);
    final DocumentSnapshot otherUserSnapshot = await otherUserRef.get();

    return _firestore.runTransaction((Transaction tx) async {
      if (myUserSnapshot.exists && otherUserSnapshot.exists) {
        await tx.update(myUserRef, <String, dynamic>{
          KEY_FOLLOWINGS: FieldValue.arrayRemove([otherUserKey])
        });

        int currentFollowers = otherUserSnapshot.data[KEY_FOLLOWERS];
        await tx.update(otherUserRef, <String, dynamic>{
          KEY_FOLLOWERS: currentFollowers-1
        });
      }
    });
  }

  Stream<List<Post>> fetchAllPostFromFollowers(List<dynamic> followings, String userKey) {
    final CollectionReference collectionReference = _firestore.collection(COLLECTION_POSTS);

    List<Stream<List<Post>>> streams = [];

    for (int i = 0; i < followings.length; i++) {
      streams.add(collectionReference
      .where(KEY_USERKEY, isEqualTo: followings[i])
      .snapshots()
      .transform(toPosts));
    }

    streams.add(collectionReference
        .where(KEY_USERKEY, isEqualTo: userKey)
        .snapshots()
        .transform(toPosts));


    return Rx.combineLatest(streams, (listOfPosts) {
      List<Post> combinedPosts = [];
      for (List<Post> posts in listOfPosts) {
        combinedPosts.addAll(posts);
      }

      return combinedPosts;
    });
  }

  Stream<List<CommentModel>> fetchAllComments(String postKey) {
    return _firestore.collection(COLLECTION_POSTS)
        .document(postKey)
        .collection(COLLECTION_COMMENTS)
        .orderBy(KEY_COMMENTTIME)
        .snapshots()
        .transform(toComments);
  }

  Future<Map<String, dynamic>> createNewComment(String postKey, Map<String, dynamic> commentData) async {

    final DocumentReference postRef = _firestore.collection(COLLECTION_POSTS).document(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();

    final DocumentReference commentRef = postRef.collection(COLLECTION_COMMENTS).document();

    return _firestore.runTransaction((Transaction tx) async {
      if (postSnapshot.exists) {
        await tx.set(commentRef, commentData);

        int numOfComments = postSnapshot.data[KEY_NUMOFCOMMENTS];
        await tx.update(postRef, {
          KEY_LASTCOMMENT: commentData[KEY_COMMENT],
          KEY_LASTCOMMENTOR: commentData[KEY_USERNAME],
          KEY_LASTCOMMENTTIME: commentData[KEY_COMMENTTIME],
          KEY_NUMOFCOMMENTS: numOfComments+1,
        });
      }
    });
  }

  Future<void> toggleLikes(String postKey, String userKey) async {
    final DocumentReference postRef = _firestore.collection(COLLECTION_POSTS).document(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      if (postSnapshot.data[KEY_NUMOFLIKES].contains(userKey)) {
        postRef.updateData({
          KEY_NUMOFLIKES: FieldValue.arrayRemove([userKey])
        });
      }
      else {
        postRef.updateData({
          KEY_NUMOFLIKES: FieldValue.arrayUnion([userKey])
        });
      }
    }
  }
}

FirestoreProvider firestoreProvider = FirestoreProvider();
