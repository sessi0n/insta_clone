import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/size.dart';
import 'package:insta_clone/data/post.dart';
import 'package:insta_clone/data/provider/my_user_data.dart';
import 'package:insta_clone/firebase/firebase_provider.dart';
import 'package:insta_clone/screens/comments_page.dart';
import 'package:insta_clone/utils/profile_img_path.dart';
import 'package:insta_clone/widgets/comment.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Post>>.value(
      value: firestoreProvider.fetchAllPostFromFollowers(
          Provider
              .of<MyUserData>(context)
              .data
              .followings
          , Provider
          .of<MyUserData>(context)
          .data
          .userKey
      ),
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: ImageIcon(
                AssetImage('assets/actionbar_camera.png'),
                color: Colors.black,
              ),
              onPressed: null,
            ),
            title: Image.asset(
              'assets/insta_text_logo.png',
              height: 26,
            ),
            actions: <Widget>[
              IconButton(
                icon: ImageIcon(
                  AssetImage('assets/actionbar_camera.png'),
                  color: Colors.black,
                ),
                onPressed: () {
//                firestoreProvider.sendData().then((_) {
//                  print('data send to firestore');
//                });
                },
              ),
              IconButton(
                icon: ImageIcon(
                  AssetImage('assets/direct_message.png'),
                  color: Colors.black,
                ),
                onPressed: () {
//                firestoreProvider.getData();
                },
              ),
            ]),
        body: Consumer<List<Post>>(
          builder: (context, postList, child) {
            return ListView.builder(
                itemCount: postList == null ? 0 : postList.length,
                itemBuilder: (BuildContext context, int index) {
//            return Container(
//              height: 300,
//                color: Colors.primaries[index % Colors.primaries.length],
//            );
                  Post post = postList[index];
                  return _feedItem(post, context);
                });
          },
        ),
      ),
    );
  }

  Column _feedItem(Post post, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _postHeader(post.username),
        _postImage(post.postUrl),
        _postAction(post),
        _postLikes(post),
        _postCaption(context, post),
        _allComments(post)
      ],
    );
  }

  Widget _allComments(Post post) {
    return Visibility(
      visible: post.numOfComments > 0,
      child: Consumer<MyUserData>(
        builder: (context, myUserData, child) {
          return FlatButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CommentsPage(
                      user: myUserData.data, postKey: post.postKey);
                }));
              },
              child: Text('show all ${post.numOfComments} comments',
                  style: TextStyle(color: Colors.grey[600])));
        },
      ),
    );
  }

  Padding _postCaption(BuildContext context, Post post) {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: common_gap, vertical: common_xs_gap),
        child: Comment(
            username: post.lastCommentor,
            caption:
            post.lastComment)
//        child: Comment(dateTime:DateTime.now(), showProfile: true, username: 'username $index', caption: 'I love summer sooooooo much fdsa fsdlkfjaslkdjf sdkf fsdklfsdlk sd fsd fsd fs d')
    );
  }

  Padding _postLikes(Post post) {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        '${post.numOfLikes.length} likes',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _postAction(Post post) {
    return Consumer<MyUserData>(
      builder: (context, myUserData, child) {
        return Row(
          children: <Widget>[
            IconButton(
              icon: ImageIcon(
                AssetImage('assets/bookmark.png'),
                color: Colors.black87,
              ),
              onPressed: null,
            ),
            IconButton(
              icon: ImageIcon(
                AssetImage('assets/comment.png'),
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CommentsPage(user: myUserData.data, postKey: post.postKey);
                }));
              },
            ),
            IconButton(
              icon: ImageIcon(
                AssetImage('assets/direct_message.png'),
                color: Colors.black87,
              ),
              onPressed: null,
            ),
            Spacer(),
            IconButton(
              icon: ImageIcon(
                AssetImage(post.numOfLikes.contains(myUserData.data.userKey) ? 'assets/heart_selected.png' : 'assets/heart.png'),
                color: Colors.redAccent,
              ),
              onPressed: () {
                firestoreProvider.toggleLikes(post.postKey, myUserData.data.userKey);
              },
            ),
          ],
        );
      },
    );
  }

  Row _postHeader(String username) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_gap),
          child: CircleAvatar(
            backgroundImage:
            CachedNetworkImageProvider(getProfileImgPath(username)),
            radius: profile_redius,
          ),
        ),
        Expanded(child: Text(username)),
        IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black87,
          ),
          onPressed: null,
        )
      ],
    );
  }

  Widget _postImage(String postUrl) {
    return CachedNetworkImage(
      imageUrl: postUrl,
      placeholder: (context, url) {
        return myProgressIndicator(
          containerSize: size.width,
          progressSize: 30,
        );
      },
      imageBuilder: (BuildContext context, ImageProvider imageProvider) =>
          AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              )),
    );
  }
}
