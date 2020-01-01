import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/size.dart';
import 'package:insta_clone/data/provider/my_user_data.dart';
import 'package:insta_clone/utils/profile_img_path.dart';
import 'package:insta_clone/widgets/profile_side_menu.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _menuOpened = false;

//  Size _size;
  double menuWidth;
  int duration = 150;

  AlignmentGeometry tabAlign = Alignment.centerLeft;
  bool _tabIconGridSelected = true;

  double _gridMargin = 0;
  double _myImgGridMargin = size.width;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: duration));
    super.initState();
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    _size = MediaQuery.of(context).size;
    menuWidth = size.width / 1.5;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _sideMenu(),
          _profile(),
        ],
      ),
    );
  }

  Widget _sideMenu() {
    return AnimatedContainer(
      width: menuWidth,
      curve: Curves.easeInOut,
      color: Colors.grey[200],
      duration: Duration(milliseconds: duration),
      transform: Matrix4.translationValues(
          _menuOpened ? size.width - menuWidth : size.width, 0, 0),
      child: SafeArea(
        child: ProfileSideMenu(),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            FlatButton(
//              child: Text('sessi0n'),
//              onPressed: null,
//            )
//          ],
//        ),
      ),
    );
  }

  Widget _profile() {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      color: Colors.transparent,
      duration: Duration(milliseconds: duration),
      transform: Matrix4.translationValues(_menuOpened ? -menuWidth : 0, 0, 0),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _usernameIconButton(),
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _getProfileHeader,
                      _username(),
                      _userbio(),
                      _editProfileButton(),
                      _getTabIconButton(),
                      _getAnimatedSelectBar(),
                    ]),
                  ),
                  _getImageGrid(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _getImageGrid(BuildContext context) => SliverToBoxAdapter(
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: duration),
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(_gridMargin, 0, 0),
              child: _imageGrid,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: duration),
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(_myImgGridMargin, 0, 0),
              child: _imageGrid,
            ),
          ],
        ),
      );

  GridView get _imageGrid => GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1,
        children: List.generate(30, (index) => _gridImgItem(index)),
      );

  CachedNetworkImage _gridImgItem(int index) => CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: 'https://picsum.photos/id/$index/100/100',
      );

  AnimatedContainer _getAnimatedSelectBar() {
    return AnimatedContainer(
      alignment: tabAlign,
      duration: Duration(milliseconds: duration),
      curve: Curves.easeInOut,
      color: Colors.transparent,
      height: 1,
      width: size.width,
      child: Container(
        height: 1,
        width: size.width / 2,
        color: Colors.black87,
      ),
    );
  }

  Row _getTabIconButton() {
    return Row(
      children: <Widget>[
        Expanded(
            child: IconButton(
          icon: ImageIcon(AssetImage('assets/grid.png'),
              color: _tabIconGridSelected ? Colors.black : Colors.black26),
          onPressed: () {
            _setTab(true);
          },
        )),
        Expanded(
            child: IconButton(
          icon: ImageIcon(AssetImage('assets/saved.png'),
              color: _tabIconGridSelected ? Colors.black26 : Colors.black),
          onPressed: () {
            _setTab(false);
          },
        ))
      ],
    );
  }

  Padding _editProfileButton() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: SizedBox(
        height: 24,
        child: DecoratedBox(
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              color: Colors.white),
          child: Theme(
            data: Theme.of(context).copyWith(
                buttonTheme: ButtonTheme.of(context).copyWith(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)),
            child: OutlineButton(
                onPressed: () => {},
                borderSide: BorderSide(color: Colors.black45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
        ),
      ),
    );
  }

  Padding _userbio() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        'bio from user, so say something.',
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
    );
  }

  Padding _username() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Consumer<MyUserData>(
        builder: (context, myUserData, child) {
          var name = '';
          if (myUserData.data != null)
            name = myUserData.data.userName;

          return Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }

  Row get _getProfileHeader => Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(getProfileImgPath('condingpapa')),
            ),
          ),
          Expanded(
            child: Table(
              children: [
                TableRow(children: [
                  _getStatusValueWidget('134243343223'),
                  _getStatusValueWidget('456'),
                  _getStatusValueWidget('789'),
                ]),
                TableRow(children: [
                  _getStatusLableWidget('Posts'),
                  _getStatusLableWidget('Followers'),
                  _getStatusLableWidget('Following'),
                ])
              ],
            ),
          )
        ],
      );

  Widget _getStatusValueWidget(String value) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: common_s_gap),
          child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ),
      );

  Widget _getStatusLableWidget(String value) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: common_s_gap),
          child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w300))),
        ),
      );

  List<Widget> _coloredContainers() {
    return List<Widget>.generate(
      20,
      (i) => Container(
          height: 150, color: Colors.primaries[i % Colors.primaries.length]),
    );
  }

  Row _usernameIconButton() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: common_gap),
          child: Text(
            'sessi0n',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        )),
        IconButton(
//            icon: Icon(Icons.menu),
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationController,

        ),
            onPressed: () {
              _menuOpened ? _animationController.reverse() : _animationController.forward();
              setState(() {
                _menuOpened = !_menuOpened;
              });
            })
      ],
    );
  }

  _setTab(bool tabLeft) {
    setState(() {
      if (tabLeft) {
        this.tabAlign = Alignment.centerLeft;
        this._tabIconGridSelected = true;
        this._gridMargin = 0;
        this._myImgGridMargin = size.width;
      } else {
        this.tabAlign = Alignment.centerRight;
        this._tabIconGridSelected = false;
        this._gridMargin = -size.width;
        this._myImgGridMargin = 0;
      }
    });
  }
}
