

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_clone/utils/simple_snack_bar.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

void signInFacebook(BuildContext context) async {
  final FacebookLogin facebookLogin = FacebookLogin();
  final result = await facebookLogin.logIn(['email']);

  switch(result.status) {
    case FacebookLoginStatus.loggedIn:
      _handleFacebookToken(context, result.accessToken.token);
      break;
    case FacebookLoginStatus.cancelledByUser:
      simpleSnackBar(context, 'user cancel, facebook login');
      break;
    case FacebookLoginStatus.error:
      print(result.errorMessage);
      simpleSnackBar(context, result.errorMessage);
      break;

  }
}

void _handleFacebookToken(BuildContext context, String token) async {
  final AuthCredential credential = FacebookAuthProvider.getCredential(
    accessToken: token,
  );

  try {

    FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;

    if (user == null) {
      simpleSnackBar(context, 'no user, facebook - firebase auth');
    }
  }
  catch(e) {
    simpleSnackBar(context, e.toString());
  }

}