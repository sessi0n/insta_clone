import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/size.dart';
import 'package:insta_clone/data/provider/my_user_data.dart';
import 'package:insta_clone/main_page.dart';
import 'package:insta_clone/service/facebook_login.dart';
import 'package:insta_clone/utils/simple_snack_bar.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatefulWidget {

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
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
              Text('Forgotten password?',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.blue[700], fontWeight: FontWeight.w600)),
              SizedBox(
                height: 2,
              ),
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _login(context);
                  }
                },
                child: Text(
                  'Log in',
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

  void _login(BuildContext context) async {
    try {
      final AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _emailController.text, password: _pwController.text);

      final FirebaseUser user = result.user;

      if (user == null) {
        simpleSnackBar(context, 'plz try again later: ');
      }
      else {
        Provider.of<MyUserData>(context).setNewStatus(MyUserDataStatus.progress);
      }
    }
    catch(e) {
      print(e.toString());
      simpleSnackBar(context, e.toString());
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
