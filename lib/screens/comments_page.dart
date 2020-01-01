import 'package:flutter/material.dart';
import 'package:insta_clone/constants/size.dart';
import 'package:insta_clone/data/comment.dart';
import 'package:insta_clone/data/user.dart';
import 'package:insta_clone/firebase/firebase_provider.dart';
import 'package:insta_clone/utils/profile_img_path.dart';
import 'package:insta_clone/widgets/comment.dart';
import 'package:provider/provider.dart';

class CommentsPage extends StatefulWidget {
  final User user;
  final String postKey;

  const CommentsPage({Key key, this.user, this.postKey}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController _commentsController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    _commentsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamProvider.value(
                  value: firestoreProvider.fetchAllComments(widget.postKey),
                  child: Consumer<List<CommentModel>>(
                    builder: (context, commentList, child) {
                      return ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: common_gap),
                          itemBuilder: (context, index) {
                            CommentModel comment = commentList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: common_gap),
                              child: Comment(
                                username: comment.username,
                                showProfile: true,
                                dateTime: comment.commentTime,
                                caption: comment.comment,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              thickness: common_gap,
                              color: Colors.transparent,
                            );
                          },
                          itemCount: commentList == null ? 0 : commentList.length);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(common_gap),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        getProfileImgPath(widget.user.userName),
                      ),
                      radius: profile_redius,
                    ),
                    SizedBox(
                      width: common_gap,
                    ),
                    Expanded(
                        child: TextFormField(
                          controller: _commentsController,
                          showCursor: true,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: InputBorder.none,
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Input Something';
                            }
                            return null;
                          },
                      ),
                    ),
                    SizedBox(
                      width: common_gap,
                    ),
                    FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          firestoreProvider.createNewComment(
                              widget.postKey,
                              CommentModel.getMapForNewComment(
                                  widget.user.userKey,
                                  widget.user.userName,
                                  _commentsController.text))
                              .then((_) {
                            _commentsController.clear();
                          });
                        }
                      },
                      child: Text(
                        'Post',
                        style: Theme.of(context).textTheme.button,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
