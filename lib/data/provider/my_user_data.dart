
import 'package:flutter/cupertino.dart';
import 'package:insta_clone/data/user.dart';

class MyUserData extends ChangeNotifier {
  User _myUserData;

  User get data => _myUserData;
  MyUserDataStatus _myUserDataStatus = MyUserDataStatus.progress;
  MyUserDataStatus get status => _myUserDataStatus;

  setUserData(User user) {
    _myUserData = user;
    _myUserDataStatus = MyUserDataStatus.exist;
    notifyListeners();

  }

  void setNewStatus(MyUserDataStatus status) {
    _myUserDataStatus = status;
    notifyListeners();
  }

  clearUserData() {
    _myUserDataStatus = MyUserDataStatus.none;
    _myUserData = null;
    notifyListeners();
  }

  bool amIFollowingThisUser(String userKey) {
    return _myUserData.followings.contains(userKey);
  }
}

enum MyUserDataStatus { progress, none, exist }