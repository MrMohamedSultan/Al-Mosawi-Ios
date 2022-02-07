import 'dart:async';
import 'dart:convert';

import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:ahmad_pro/sharedPreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';

class DatabaseServices {
  final int userid;
  final BuildContext context;
  final controller = StreamController<Users>();
  DatabaseServices({@required this.context, this.userid});
  Map<String, dynamic> map;
  gituserData() async {
    try {
      var response = await http.get(Utils.MyAccount_URL + '/$userid');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(response.statusCode.toString());
        final user = _userFromDatabaseUser(data, context);
        controller.add(user);
      } else if (response.statusCode == 201) {
        final data = json.decode(response.body);

        final user = _userFromDatabaseUser(data, context);
        controller.add(user);
      } else {
        print(response.statusCode.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Users _userFromDatabaseUser(Map user, BuildContext context) {
    return user != null
        ? Users(
            name: user['data']['name'].toString(),
            uniqueName: user['data']['uniqueName'].toString(),
            userId: user['data']['id'],
            phoneNumber: (user['data']['mobile'] != null)
                ? user['data']['mobile'].toString()
                : 'اضف رقم الهاتف',
            email: (user['data']['email'] != null)
                ? user['data']['email'].toString()
                : 'اضف البريد الالكتروني',
          )
        : null;
  }

  upDateUserData(
      {String phone,
      String pass,
      String nicename,
      String email,
      BuildContext context}) async {
    try {
      var data;
      data = FormData.fromMap({
        "user_email": '$email',
        'user_nicename': "$nicename",
        'user_pass': "$pass",
        'phone': "$phone",
      });
      Dio dio = new Dio();

      Response response =
          await dio.post(Utils.UpdateMyAccount_URL + "/$userid", data: data);
      print(response.data.toString());
      if (response.data['status'] == 'success') {
        if (pass != User.userPassword) {
          MySharedPreferences.saveUserUserPassword(pass);
        }
        showMyDialog(context: context, message: response.data['message']);
      } else {
        showMyDialog(
            context: context, message: response.data['errorArr'].toString());
      }
    } catch (e) {
      print('errrrroe Upadata Data');

      print(e.toString());
    }
  }

  Stream<Users> get userData {
    gituserData();
    return controller.stream;
  }
}

Future<void> showMyDialog({BuildContext context, var message}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                message,
                style: AppTheme.heading.copyWith(
                  color: customColor,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'الغاء',
              style: AppTheme.heading.copyWith(
                color: customColor,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class Users {
  final int userId;
  final String phoneNumber;
  final String name;
  final String uniqueName;
  final String email;

  Users({
    this.uniqueName,
    this.name,
    this.email,
    this.phoneNumber,
    this.userId,
  });
}
