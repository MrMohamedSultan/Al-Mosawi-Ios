import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/services/UserData.dart';
import 'package:ahmad_pro/sharedPreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  bool obscurePassword = true;
  String phoneNamber;
  String password;
  String name;
  String email;
  getUserPass() async {
    User.userPassword = await MySharedPreferences.getUserUserPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل بياناتك'),
      ),
      body: StreamBuilder<Users>(
        stream:
            DatabaseServices(userid: User.userid, context: context).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Users userData = snapshot.data;

            return SafeArea(
              child: ListView(
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الاسم',
                          style: AppTheme.heading.copyWith(fontSize: 15),
                        ),
                        TextFormField(
                          initialValue: userData.name,
                          decoration:
                              textFormInpuofEidtProfile(icon: Icons.edit),
                          onChanged: (val) {
                            setState(() {
                              name = val;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          'رقم الهاتف ',
                          style: AppTheme.heading.copyWith(fontSize: 15),
                        ),
                        TextFormField(
                          initialValue: userData.phoneNumber,
                          onChanged: (val) {
                            setState(() {
                              phoneNamber = val;
                            });
                          },
                          decoration: textFormInpuofEidtProfile(
                            icon: Icons.edit,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'البريد الابكتروني ',
                          style: AppTheme.heading.copyWith(fontSize: 15),
                        ),
                        TextFormField(
                          initialValue: userData.email,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          decoration:
                              textFormInpuofEidtProfile(icon: Icons.edit),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'الرقم السري',
                          style: AppTheme.heading.copyWith(fontSize: 15),
                        ),
                        TextFormField(
                          initialValue: User.userPassword,
                          decoration: textFormInputDecorationForPassword(
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
                          obscureText: obscurePassword,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: CustomButton(
                            onPress: () {
                              DatabaseServices(
                                userid: User.userid,
                                context: context,
                              ).upDateUserData(
                                pass: (password) ?? User.userPassword,
                                email: (email) ?? userData.email,
                                nicename: (name) ?? userData.name,
                                phone: (phoneNamber) ?? userData.phoneNumber,
                                context: context,
                              );
                            },
                            text: 'حفظ',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
        },
      ),
    );
  }
}
