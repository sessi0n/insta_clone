import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/size.dart';
import 'package:insta_clone/data/provider/my_user_data.dart';
import 'package:insta_clone/screens/auth_page.dart';
import 'package:provider/provider.dart';


class ProfileSideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey[300])),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: Text(
              'Settings',
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.grey[300],
            height: 1,
          ),
          FlatButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Provider.of<MyUserData>(context).clearUserData();
              },
              icon: Icon(Icons.exit_to_app),
              label: Text('Log out',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w500)))
        ],
      ),
    );
  }
}
