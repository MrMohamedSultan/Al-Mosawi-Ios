import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/secreens/wrapper/wrapper.dart';
import 'package:ahmad_pro/services/network_sensitive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ahmad_pro/models/abutUsApi.dart';

import '../../../sharedPreferences.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  String userName = '';
  String email = '';
  String error = '';

  bool obscurePassword = true;
  bool checkBoxValue = false;
  bool obscureconPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColor,
        toolbarHeight: 0,
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
                    text: 'إنشاء حساب جديد',
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
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: textFormInputDecoration(
                                    prefixIcon: Icons.person,
                                    label: 'الاسم',
                                  ),
                                  validator: (val) =>
                                      val.isEmpty ? nameEror : null,
                                  onChanged: (val) {
                                    setState(() {
                                      name = val;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: textFormInputDecoration(
                                    prefixIcon: Icons.person,
                                    label: 'اسم المستخدم',
                                  ),
                                  validator: (val) =>
                                      val.isEmpty ? nameEror : null,
                                  onChanged: (val) {
                                    setState(() {
                                      userName = val;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),
                                // TextFormField(
                                //   style: TextStyle(color: Colors.black),
                                //   keyboardType: TextInputType.phone,
                                //   decoration: textFormInputDecoration(
                                //     prefixIcon: Icons.phone,
                                //     label: 'رقم الهاتف',
                                //   ),
                                //   validator: (val) =>
                                //       val.isEmpty ? phoneEror : null,
                                //   onChanged: (val) {
                                //     setState(() {
                                //       phoneNumber = val;
                                //     });
                                //   },
                                // ),
                                IntlPhoneField(
                                  initialCountryCode: 'KW',
                                  decoration: textFormInputDecoration(
                                    prefixIcon: Icons.phone,
                                    label: 'رقم الهاتف',
                                  ),
                                  autoValidate: false,
                                  validator: (val) =>
                                      val.isEmpty ? phoneEror : null,
                                  onChanged: (phone) {
                                    setState(() {
                                      phoneNumber = phone.completeNumber;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: textFormInputDecoration(
                                    prefixIcon: Icons.email,
                                    label: 'البريد الإلكتروني',
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
                                  validator: (val) => validatePassord(val),
                                  obscureText: obscurePassword,
                                  onChanged: (val) {
                                    setState(() {
                                      password = val;
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
                                    'تأكيد كلمه المرور',
                                    () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                      });
                                    },
                                    obscurePassword,
                                  ),
                                  validator: (val) => validateConfrimPassord(
                                    val,
                                    password,
                                    confirmPassword,
                                  ),
                                  obscureText: obscurePassword,
                                  onChanged: (val) {
                                    setState(() {
                                      confirmPassword = val;
                                    });
                                  },
                                ),
                                Center(
                                  child: Text(
                                    error,
                                    style: AppTheme.headingColorBlue,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: checkBoxValue,
                                          activeColor: Colors.green,
                                          onChanged: (bool newValue) {
                                            setState(() {
                                              checkBoxValue = newValue;
                                              print(checkBoxValue);
                                            });
                                          },
                                        ),
                                        Text(
                                          "موافق علي الشروط والأحكام",
                                          style: AppTheme.subHeading.copyWith(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showSettingsPanel(
                                          child: policies(),
                                          context: context,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "الشروط والأحكام",
                                            style: AppTheme.subHeading.copyWith(
                                              fontSize: 10,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            FontAwesomeIcons.chevronDown,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                        if (checkBoxValue != true) {
                                          showMyDialog(
                                              context: context,
                                              message:
                                                  'يجب الموافقة علي الشروط و الاحكام اولا');
                                        } else {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                            });

                                            registerWithPhoneAndPassword(
                                              user_email: email,
                                              user_login: userName,
                                              user_nicename: name,
                                              user_pass: password,
                                              user_pass_confirmation:
                                                  confirmPassword,
                                              phone: phoneNumber,
                                            );
                                          }
                                        }
                                      },
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              .9,
                                      height: 48,
                                      child: Text(
                                        'تسجيل عصوية جديدة',
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
                                //     if (checkBoxValue != true) {
                                //       showMyDialog(
                                //           context: context,
                                //           message:
                                //               'يجب الموافقة علي الشروط و الاحكام اولا');
                                //     } else {
                                //       if (_formKey.currentState.validate()) {
                                //         setState(() {
                                //           loading = true;
                                //         });

                                //         registerWithPhoneAndPassword(
                                //           user_email: email,
                                //           user_login: userName,
                                //           user_nicename: name,
                                //           user_pass: password,
                                //           user_pass_confirmation:
                                //               confirmPassword,
                                //           phone: phoneNumber,
                                //         );
                                //       }
                                //     }
                                //   },
                                //   text: 'تسجيل عصوية جديدة',
                                // ),
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
                                          "هل لديك حساب بالفعل ؟",
                                          style: AppTheme.subHeading.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => widget.toggleView(),
                                          child: Text(
                                            "تسجيل دخول",
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
                                    SizedBox(height: 10),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          MySharedPreferences.saveUserSkipLogIn(
                                              true);
                                          MySharedPreferences.saveUserSingIn(
                                              true);
                                          MySharedPreferences.saveUserCantBuy(
                                              true);
                                          MySharedPreferences.saveUserOnBording(
                                              true);

                                          User.userSkipLogIn = true;
                                        });
                                        User.userSkipLogIn =
                                            await MySharedPreferences
                                                .getUserSkipLogIn();
                                        User.userLogIn =
                                            await MySharedPreferences
                                                .getUserSingIn();
                                        User.isOnBording =
                                            await MySharedPreferences
                                                .getUserOnBording();

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (_) => Wrapper(),
                                          ),
                                          (routes) => false,
                                        );
                                      },
                                      child: Text(
                                        "الدخول كزائر ؟",
                                        style:
                                            AppTheme.headingColorBlue.copyWith(
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
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  FutureBuilder<Policies> policies() {
    return FutureBuilder(
      future: AboutUsApi.futchPolicies(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return (snapshot.data == null)
              ? Container()
              : ListView(
                  shrinkWrap: true,
                  primary: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  children: [
                    Center(
                      child: Text(
                        snapshot.data.title,
                        style: AppTheme.heading.copyWith(
                          color: customColor,
                        ),
                      ),
                    ),
                    Text(
                      parseHtmlString(snapshot.data.des),
                      style: AppTheme.subHeading,
                    ),
                  ],
                );
        } else {
          return Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }

  registerWithPhoneAndPassword({
    String phone,
    // ignore: non_constant_identifier_names
    String user_pass,
    // ignore: non_constant_identifier_names
    String user_email,
    // ignore: non_constant_identifier_names
    String user_login,
    // ignore: non_constant_identifier_names
    String user_pass_confirmation,
    // ignore: non_constant_identifier_names
    String user_nicename,
  }) async {
    try {
      // Dio dio = new Dio();

      var response = await http.post(
        Utils.REGISTER_URL,
        // Utils.REGISTER_URL,
        body: {
          'user_login': user_login,
          'phone': phone,
          'user_pass': user_pass,
          'user_email': user_email,
          'user_pass_confirmation': user_pass_confirmation,
          'user_nicename': user_nicename,
          'deviceToken': User.userToken,
        },
      );

      Map<String, dynamic> map = json.decode(response.body);
      print('stuates Code:${response.statusCode}');

      if (map['status'] == 'success') {
        MySharedPreferences.saveUserUserPassword(password);
        MySharedPreferences.saveUserUserid(map['Data']['id']);

        MySharedPreferences.saveUserSkipLogIn(true);
        MySharedPreferences.saveUserOnBording(true);
        MySharedPreferences.saveUserSingIn(false);
        MySharedPreferences.saveUserCantBuy(false);

        User.userLogIn = await MySharedPreferences.getUserSingIn();
        User.isOnBording = await MySharedPreferences.getUserOnBording();
        User.userSkipLogIn = await MySharedPreferences.getUserSkipLogIn();
        User.userCantBuy = await MySharedPreferences.getUserCantBuy();
        User.userid = await MySharedPreferences.getUserUserid();

        User.userid = map['Data']['id'];

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => Wrapper(),
          ),
        );
      } else if (map['status'] == 'success') {
        setState(() {
          loading = false;
        });
        showMyDialog(context: context, message: map['message'].toString());
      } else {
        setState(() {
          loading = false;
        });
        showMyDialog(context: context, message: map['errorArr'].toString());
      }

      // Navigator.pop(context);
    } catch (e) {
      print('Cash errrrrrrrrrrrrrrror');
      setState(() {
        loading = false;
      });

      print(e.toString());
    }
  }

  String validatePassord(String val) {
    if (val.isEmpty) {
      return passEror;
    } else if (val.length < 6) {
      return 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';
    } else {
      return null;
    }
  }

  String validateConfrimPassord(
    String val,
    String password,
    String confrimPassord,
  ) {
    if (val.isEmpty) {
      return passEror;
    } else if (password != confirmPassword) {
      return 'كلمة المرور غير متطابقة';
    } else {
      return null;
    }
  }
}
