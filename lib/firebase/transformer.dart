
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/data/comment.dart';
import 'package:insta_clone/data/post.dart';
import 'package:insta_clone/data/user.dart';

class Transformer {
  final toUser = StreamTransformer<DocumentSnapshot, User>.fromHandlers(
    handleData: (snapshot, sink) async {
      sink.add(User.fromSnapshot(snapshot));
    }
  );

  final toUsers = StreamTransformer<QuerySnapshot, List<User>>.fromHandlers(
    handleData: (snapshot, sink) {
      List<User> users = [];
      snapshot.documents.forEach((doc) {
        users.add(User.fromSnapshot(doc));
      });
      sink.add(users);
    }
  );

  final toPosts = StreamTransformer<QuerySnapshot, List<Post>>.fromHandlers(
      handleData: (snapshot, sink) {
        List<Post> posts = [];
        snapshot.documents.forEach((doc) {
          posts.add(Post.fromSnapShot(doc));
        });
        sink.add(posts);
      }
  );

  final toUsersExceptMine = StreamTransformer<QuerySnapshot, List<User>>.fromHandlers(
      handleData: (snapshot, sink) async {
        List<User> users = [];
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        snapshot.documents.forEach((doc) {
          if (user.uid != doc.documentID)
            users.add(User.fromSnapshot(doc));
        });
        sink.add(users);
      }
  );

  final toComments = StreamTransformer<QuerySnapshot, List<CommentModel>>.fromHandlers(
    handleData: (snapshot, sink) {
      List<CommentModel> comments = [];
      snapshot.documents.forEach((doc) {
        comments.add(CommentModel.fromSnapshot(doc));
      });
      sink.add(comments);
    }
  );
}