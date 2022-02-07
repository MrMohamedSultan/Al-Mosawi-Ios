import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/secreens/wrapper/wrapper.dart';
import 'package:ahmad_pro/services/homeProvider.dart';
import 'package:ahmad_pro/services/network_sensitive.dart';
import 'package:ahmad_pro/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../passwordRecovery.dart';

class LogIn extends StatefulWidget {
  final Function toggleView;
  LogIn({this.toggleView});
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  bool obscurePassword = true;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: (loading)
          ? Container(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : NetworkSensitive(
              child: ListView(
                shrinkWrap: true,
                primary: true,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                children: [
                  LogoContainar(
                    text: 'تسجيل دخول',
                  ),
                  SizedBox(height: 20),
                  Text(
                    'مرحبا بك ',
                    style: AppTheme.heading.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        primary: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.text,
                                  decoration: textFormInputDecoration(
                                    prefixIcon: Icons.person,
                                    label: 'اسم المستخدم او البريد الالكتروني',
                                  ),
                                  validator: (val) =>
                                      val.isEmpty ? emailEror : null,
                                  onChanged: (val) {
                                    setState(() {
                                      email = val;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  decoration:
                                      textFormInputDecorationForPassword(
                                    Icons.visibility_off,
                                    Icons.lock,
                                    'كلمة المرور',
                                    () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                      });
                                    },
                                    obscurePassword,
                                  ),
                                  validator: (val) =>
                                      val.isEmpty ? passwordEror : null,
                                  obscureText: obscurePassword,
                                  onChanged: (val) {
                                    setState(() {
                                      password = val;
                                    });
                                  },
                                ),
                                Center(
                                  child: Text(
                                    error,
                                    style: AppTheme.headingColorBlue,
                                  ),
                                ),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      MySharedPreferences.saveUserSkipLogIn(
                                          true);
                                      MySharedPreferences.saveUserSingIn(true);
                                      MySharedPreferences.saveUserCantBuy(true);
                                      MySharedPreferences.saveUserOnBording(
                                          true);

                                      User.userSkipLogIn = true;
                                    });
                                    User.userSkipLogIn =
                                        await MySharedPreferences
                                            .getUserSkipLogIn();
                                    User.userLogIn = await MySharedPreferences
                                        .getUserSingIn();
                                    User.isOnBording = await MySharedPreferences
                                        .getUserOnBording();

                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => Wrapper(),
                                      ),
                                      (routes) => false,
                                    );
                                  },
                                  child: Text(
                                    "الدخول كزائر ؟",
                                    style: AppTheme.heading.copyWith(
                                      color: customColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Material(
                                    elevation: 6,
                                    borderRadius: BorderRadius.circular(10),
                                    color: customColor,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });

                                          loginWithPhoneAndPassword(
                                            email: email,
                                            password: password,
                                          );
                                        }
                                      },
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              .75,
                                      height: 48,
                                      child: Text(
                                        'دخول',
                                        style: AppTheme.heading.copyWith(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // CustomButton(
                                //   onPress: () async {
                                //     if (_formKey.currentState.validate()) {
                                //       setState(() {
                                //         loading = true;
                                //       });

                                //       loginWithPhoneAndPassword(
                                //         email: email,
                                //         password: password,
                                //       );
                                //     }
                                //   },
                                //   text: 'دخول',
                                // ),
                                SizedBox(height: 12),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => PasswordRecovery(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'هل نسيت كلمه السر  ؟ ',
                                    style: AppTheme.heading,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "ليس لديك حساب ؟",
                                          style: AppTheme.subHeadingColorBlue
                                              .copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => widget.toggleView(),
                                          child: Text(
                                            "إنشاء حساب",
                                            style: AppTheme.headingColorBlue
                                                .copyWith(
                                              fontWeight: FontWeight.w900,
                                              color: customColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  checkUserSubscriptions({int id}) async {
    try {
      print('User.useridwarrrrrwew:$id');
      var response = await http.post(Utils.CheckUserSubscriptions_URL, body: {
        'user_id': id.toString(),
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

  loginWithPhoneAndPassword({
    String password,
    String email,
  }) async {
    try {
      print("password: ${password}");
      print("email: ${email}");
      print("Login_URL: ${Utils.Login_URL}");
      var response = await http.post(
        Utils.Login_URL,
        // Utils.REGISTER_URL,
        body: {
          'password': password,
          'email': email,
          // 'deviceToken': User.userToken,
        },
      );
      print("logged user: ${response}");

      Map<String, dynamic> map = json.decode(response.body);

      if (map['success'] == 'تم تسجيل الدخول بنجاح') {
        MySharedPreferences.saveUserUserPassword(password);
        MySharedPreferences.saveUserUserid(map['UserData']['id']);
        MySharedPreferences.saveUserCourses(map['UserData']['Courses']);
        MySharedPreferences.saveUserproChat(map['UserData']['proChartRooms']);
        MySharedPreferences.saveUserUserRecomendations(
            map['UserData']['Recomendations']);

        if (map['UserData']['Recomendations'] == '0') {
          User.userSkipLogIn = true;

          MySharedPreferences.saveUserSingIn(true);
          MySharedPreferences.saveUserOnBording(true);
          MySharedPreferences.saveUserCantBuy(false);

          User.userLogIn = await MySharedPreferences.getUserSingIn();
          User.userSkipLogIn = await MySharedPreferences.getUserSkipLogIn();
          User.userCantBuy = await MySharedPreferences.getUserCantBuy();
          User.userid = await MySharedPreferences.getUserUserid();
          checkUserSubscriptions(
            id: map['UserData']['id'],
          );
        } else {
          User.userSkipLogIn = false;
          MySharedPreferences.saveUserSingIn(true);
          MySharedPreferences.saveUserOnBording(true);

          MySharedPreferences.saveUserCantBuy(false);

          User.userLogIn = await MySharedPreferences.getUserSingIn();
          User.userSkipLogIn = await MySharedPreferences.getUserSkipLogIn();
          User.userCantBuy = await MySharedPreferences.getUserCantBuy();
          User.userid = await MySharedPreferences.getUserUserid();
          User.isOnBording = await MySharedPreferences.getUserOnBording();
          checkUserSubscriptions(id: map['UserData']['id']);
        }

        User.userid = map['UserData']['id'];

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => Wrapper(),
          ),
        );
      } else if (map['status'] == 'error') {
        setState(() {
          loading = false;
        });
        showMyDialog(context: context, message: map['message'].toString());
      } else {
        setState(() {
          loading = false;
        });
        map['errorArr'] == null
            ? showMyDialog(context: context, message: map['error'].toString())
            : showMyDialog(
                context: context, message: map['errorArr'].toString());
      }

      // Navigator.pop(context);
    } catch (e) {
      print('Cash errrrrrrrrrrrrrrror ${e}');
      setState(() {
        loading = false;
      });

      print(e);
    }
  }
}
