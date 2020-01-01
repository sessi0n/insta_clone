import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/size.dart';
import 'package:insta_clone/data/user.dart';
import 'package:insta_clone/screens/share_post_page.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  final User user;

  const CameraPage({Key key, @required this.camera, @required this.user})
      : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  int _selectedIndex = 1;
  PageController _pageController = PageController(initialPage: 1);

  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          _takeGellayPage(),
          _takePhotoPage(),
          _takeVideoPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 0,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.grey[400],
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[50],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/grid.png')),
              title: Text('GALLERY')),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/grid.png')),
              title: Text('PHOTO')),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/grid.png')),
              title: Text('VIDEO')),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Widget _takeGellayPage() {
    return Container(
      color: Colors.green,
    );
  }

  Widget _takePhotoPage() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && _controller.value.isInitialized)
          return cameraPreviewing();
        else
          return myProgressIndicator();
      },
    );
  }

  Column cameraPreviewing() {
    return Column(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.width,
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Container(
                  width: size.width,
                  height: size.width / _controller.value.aspectRatio,
                  child: CameraPreview(_controller),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _attemptTakePhoto(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(common_l_gap),
              child: Center(
                child: Container(
                  decoration: ShapeDecoration(
                      shape: CircleBorder(
                          side:
                              BorderSide(color: Colors.grey[300], width: 20))),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _takeVideoPage() {
    return Container(
      color: Colors.deepOrange,
    );
  }

  void _attemptTakePhoto(BuildContext context) async {
    try {
      await _initializeControllerFuture;
      final path = (await getTemporaryDirectory()).path
        + '${DateTime.now()}_${widget.user.userName}.png';

      print(path);
      final String postKey = '${DateTime.now().millisecondsSinceEpoch}_${widget.user.userKey}';

      await _controller.takePicture(path);
      Navigator.push(
          context,
        MaterialPageRoute(
          builder: (context) => SharePostPage(
            imgFile: File(path),
            postKey: postKey,
            user: widget.user,
          ),
        )
      );
    } catch (e) {
      print(e);
    }
  }
}
