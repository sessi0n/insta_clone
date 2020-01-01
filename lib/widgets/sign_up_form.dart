import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/size.dart';
import 'package:insta_clone/data/provider/my_user_data.dart';
import 'package:insta_clone/firebase/firebase_provider.dart';

import 'package:insta_clone/service/facebook_login.dart';
import 'package:insta_clone/utils/simple_snack_bar.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _cpwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _cpwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Form(
          key: _formKey,
          child: ListView(
//            mainAxisAlignment: MainAxisAlignment.center,
//            mainAxisSize: MainAxisSize.max,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 6,
              ),
              Image.asset('assets/insta_text_logo.png'),
              SizedBox(
                height: 1,
              ),
              TextFormField(
                controller: _emailController,
                decoration: getTextFieldDecoor('Email'),
                validator: (String value) {
                  if (value.isEmpty || !value.contains('@'))
                    return 'invalid email';
                  return null;
                },
              ),
              SizedBox(
                height: 1,
              ),
              TextFormField(
                controller: _pwController,
                decoration: getTextFieldDecoor('PassWord'),
                validator: (String value) {
                  if (value.isEmpty) return 'invalid password';
                  return null;
                },
              ),
              SizedBox(
                height: 1,
              ),
              TextFormField(
                controller: _cpwController,
                decoration: getTextFieldDecoor('Confirm PassWord'),
                validator: (String value) {
                  if (value.isEmpty || value != _pwController.text)
                    return 'Password does not match';
                  return null;
                },
              ),
              SizedBox(
                height: 2,
              ),
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _register(context);
                  }
                },
                child: Text(
                  'Join',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                disabledColor: Colors.blue[100],
              ),
              SizedBox(
                height: 2,
              ),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    left: 0,
                    right: 0,
                    height: 1,
                    child: Container(
                      color: Colors.grey[300],
                      height: 1,
                    ),
                  ),
                  Container(
                    height: 3,
                    width: 50,
                    color: Colors.grey[50],
                  ),
                  Text(
                    'OR',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 2,
              ),
              FlatButton.icon(
                textColor: Colors.blue,
                onPressed: () {
                  signInFacebook(context);
                },
                icon: ImageIcon(AssetImage('assets/icon/facebook.png')),
                label: Text('Login with Facebook '),
              ),
              SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context) async {

    final AuthResult result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _pwController.text);

    final FirebaseUser user = result.user;

    if (user == null) {
      simpleSnackBar(context, 'plz try again later: ');
    }
    else {
      await firestoreProvider.attempCreateUser(userKey: user.uid, email: user.email);
      Provider.of<MyUserData>(context).setNewStatus(MyUserDataStatus.progress);
    }
  }

  InputDecoration getTextFieldDecoor(String hint) {
    return InputDecoration(
        hintText: hint,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300], width: 1),
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300], width: 1),
            borderRadius: BorderRadius.circular(12)),
        fillColor: Colors.grey[100],
        filled: true);
  }
}
