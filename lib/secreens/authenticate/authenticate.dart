import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/secreens/authenticate/register/register.dart';
import 'package:ahmad_pro/secreens/wrapper/wrapper.dart';
import 'package:ahmad_pro/services/homeProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../sharedPreferences.dart';
import 'logIn/login.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  // final FirebaseMessaging _fcm = FirebaseMessaging();
  getDateOfUser() async {}

  @override
  void initState() {
    // _fcm.getToken().then(
    //   (token) {
    //     print(token);
    //     MySharedPreferences.saveUserToken(token.toString());
    //   },
    // );
    if (User.userid != null) {
      checkUserSubscriptions();
    }
    getUserToken();
    super.initState();
  }

  getUserToken() async {
    User.userToken = await MySharedPreferences.getUserToken();
    User.userLogIn = await MySharedPreferences.getUserSingIn();
    User.userid = await MySharedPreferences.getUserUserid();
    User.isOnBording = await MySharedPreferences.getUserOnBording();
  }

  checkUserSubscriptions() async {
    try {
      print('User.useridwarrrrrwew:${User.userid}');
      var response = await http.post(Utils.CheckUserSubscriptions_URL, body: {
        'user_id': User.userid.toString(),
      });
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success') {
        print('proChartRooms' + jsonData['UserData']['proChartRooms']);
        if (jsonData['UserData']['Recomendations'] == '0') {
          Provider.of<CheckUserSubscriptionsProvider>(context, listen: false)
              .checkUserSubscriptions(false);
          MySharedPreferences.saveUserSkipLogIn(true);
          User.userSkipLogIn = true;

          User.userSkipLogIn = await MySharedPreferences.getUserSkipLogIn();
        } else {
          Provider.of<CheckUserSubscriptionsProvider>(context, listen: false)
              .checkUserSubscriptions(true);
          MySharedPreferences.saveUserSkipLogIn(false);
          User.userSkipLogIn = false;

          User.userSkipLogIn = await MySharedPreferences.getUserSkipLogIn();
        }
        User.userSkipLogIn = await MySharedPreferences.getUserSkipLogIn();
      } else {}
    } catch (e) {
      print('Cash wallpaper');
      setState(() {});

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (User.userid == null) {
      if (showSignIn) {
        return Container(
          child: LogIn(toggleView: toggleView),
        );
      } else {
        return Container(
          child: Register(toggleView: toggleView),
        );
      }
    } else {
      return Wrapper();
    }
  }
}
