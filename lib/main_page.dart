import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/data/provider/my_user_data.dart';
import 'package:insta_clone/screens/camera_page.dart';
import 'package:insta_clone/screens/feed_page.dart';
import 'package:insta_clone/screens/profile_page.dart';
import 'package:insta_clone/screens/search_page.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';

import 'constants/size.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    FeedPage(),
    SearchPage(),
    CameraPage(),
    myProgressIndicator(progressSize: 100,),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (size == null) {
      size = MediaQuery.of(context).size;
    }
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey[900],
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(249, 249, 249, 1),
        items: <BottomNavigationBarItem>[
          _buildNavigationBarItem(activeIconPath: 'assets/home_selected.png', iconPath: 'assets/home.png'),
          _buildNavigationBarItem(activeIconPath: 'assets/search_selected.png', iconPath: 'assets/search.png'),
          _buildNavigationBarItem(iconPath: 'assets/add.png'),
          _buildNavigationBarItem(activeIconPath: 'assets/heart_selected.png', iconPath: 'assets/heart.png'),
          _buildNavigationBarItem(activeIconPath: 'assets/profile_selected.png', iconPath: 'assets/profile.png'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem({String activeIconPath, String iconPath}) {
    return BottomNavigationBarItem(
      activeIcon: activeIconPath == null ? null : ImageIcon(AssetImage(activeIconPath)),
      icon: ImageIcon(AssetImage(iconPath)),
      title: Text(''),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    setState(() {
      if (index == 2)
        OpenCamera(context);
      else
        _selectedIndex = index;
    });
  }

  void OpenCamera(BuildContext context) async {
    final camera = await availableCameras();
    final firstCamera = camera.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(
          camera: firstCamera,
          user: Provider.of<MyUserData>(context).data,
        )
      )
    );
  }
}
