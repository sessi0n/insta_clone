import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/material_white_color.dart';
import 'package:insta_clone/data/provider/my_user_data.dart';
import 'package:insta_clone/firebase/firebase_provider.dart';
import 'package:insta_clone/main_page.dart';

import 'package:insta_clone/screens/auth_page.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';

void main() {
  var userData = MyUserData();
  return runApp(ChangeNotifierProvider.value(value: userData, child: MyApp()));
}

bool isItFirstData = true;
bool flag = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      home: AuthPage(),
      home: Consumer<MyUserData>(
        builder: (context, myUserData, child) {
          print('status: ' + myUserData.status.toString());
          switch (myUserData.status) {
            case MyUserDataStatus.progress:
              FirebaseAuth.instance.currentUser().then((firebaseUser) {
                if (firebaseUser == null)
                  myUserData.setNewStatus(MyUserDataStatus.none);
                else
                  firestoreProvider
                      .connectMyUserData(firebaseUser.uid)
                      .listen((user) {
                    myUserData.setUserData(user);
                  });
              });

              return myProgressIndicator();

            case MyUserDataStatus.exist:
              return MainPage();
            default:
              return AuthPage();
          }
        },
      ),

      theme: ThemeData(
        primarySwatch: white,
      ),
    );
  }

  StreamBuilder<FirebaseUser> buildStreamBuilder() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (isItFirstData) {
          isItFirstData = false;
          return myProgressIndicator();
        } else {
          print('FirebaseAuth: onAuthStateChanged: 1');
          if (flag) return MainPage();

          print('FirebaseAuth: onAuthStateChanged: 2');
          if (snapshot.hasData) {
            print('FirebaseAuth: onAuthStateChanged: 3');
            firestoreProvider.attempCreateUser(
                userKey: snapshot.data.uid, email: snapshot.data.email);

            var myUserData = Provider.of<MyUserData>(context);
            firestoreProvider
                .connectMyUserData(snapshot.data.uid)
                .listen((user) {
              myUserData.setUserData(user);
            });
            flag = true;
            return MainPage();
          } else
            return AuthPage();
        }
      },
    );
  }
}
