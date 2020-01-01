import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';
import 'package:insta_clone/constants/size.dart';
import 'package:insta_clone/data/isolates/resize_image.dart';
import 'package:insta_clone/data/post.dart';
import 'package:insta_clone/data/user.dart';
import 'package:insta_clone/firebase/firebase_provider.dart';
import 'package:insta_clone/firebase/firebase_storage.dart';
import 'package:insta_clone/utils/post_path.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:insta_clone/widgets/share_switch.dart';

class SharePostPage extends StatefulWidget {
  final File imgFile;
  final String postKey;
  final User user;

  const SharePostPage(
      {Key key,
      @required this.imgFile,
      @required this.postKey,
      @required this.user})
      : super(key: key);

  @override
  _SharePostPageState createState() => _SharePostPageState();
}

class _SharePostPageState extends State<SharePostPage> {
  TextEditingController captionController = TextEditingController();
  bool _isImgProcessing = false;

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IgnorePointer(
          ignoring: _isImgProcessing,

//          ignoringSemantics: _isImgProcessing,
          child: Scaffold(
            appBar: _appBar(),
            body: ListView(
              children: <Widget>[
                _thumnailNCaption(),
                _divider,
                _sectionTitle(context, 'Tag People'),
                _divider,
                _sectionTitle(context, 'Add Location'),
                _divider,
                _addLocationTag(),
                _divider,
                _sectionTitle(context, 'Also post to'),
                ShareSwitch(label: 'Facebook'),
                ShareSwitch(label: 'Twitter'),
                ShareSwitch(label: 'Tumblr'),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isImgProcessing,
          child: Center(
            child: myProgressIndicator(),
          ),
        )
      ],
    );
  }

  void _uploadImageNCreateNewPost() async {
    setState(() {
      _isImgProcessing = true;
      FocusScope.of(context).requestFocus(FocusNode());
    });

    try {
      final File resized = await compute(getResizedImage, widget.imgFile);

      dynamic downloadUrl =
          await storageProvider.uploadImg(resized, getImgPath(widget.postKey));

      final Map<String, dynamic> postData = Post.getMapForNewPost(
          widget.user.userKey,
          widget.user.userName,
          widget.postKey,
          downloadUrl,
          captionController.text);
      await firestoreProvider.createNewPost(widget.postKey, postData);

//      widget.imgFile.length().then((length) => print('image size :  $length'));
//      resized.length().then((length) {
//        print('resized image size: $length');
//      });
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      _isImgProcessing = false;
    });

    Navigator.of(context).pop();
  }

  Divider get _divider => Divider(
        color: Colors.grey[200],
        thickness: 1,
      );

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text('New Post'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _uploadImageNCreateNewPost();
          },
          child: Text(
            'Share',
            textScaleFactor: 1.4,
            style: TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
  }

  Row _thumnailNCaption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_gap),
          child: Image.file(
            widget.imgFile,
            width: size.width / 6,
            height: size.width / 6,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: TextField(
            controller: captionController,
            autofocus: true,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Write a caption...'),
          ),
        )
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(title, style: Theme.of(context).textTheme.subtitle),
    );
  }

  Tags _addLocationTag() {
    List<String> _items = [
      'sfa',
      'f23dsfsadfa324ff',
      '3hff8943',
      'fjerf98j439',
      '8j943p',
      'wfj8szaj98jpqa439',
      'jp9jsdp9',
      'fj89p43jfp98j',
      'dsfjvknxc',
      'ijv',
      'n98rejvkj',
      'fhng',
      'sfa',
      'f23dsfsadfa324ff',
      '3hff8943',
      'fjerf98j439',
      '8j943p',
      'wfj8szaj98jpqa439',
      'jp9jsdp9',
      'fj89p43jfp98j',
      'dsfjvknxc',
      'ijv',
      'n98rejvkj',
      'fhng',
    ];
    return Tags(
      horizontalScroll: true,
      itemCount: _items.length,
      itemBuilder: (int index) {
        final item = _items[index];
        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          activeColor: Colors.grey[200],
          textActiveColor: Colors.black54,
          textStyle: TextStyle(fontSize: 13),
          borderRadius: BorderRadius.circular(3),
        );
      },
    );
  }
}
