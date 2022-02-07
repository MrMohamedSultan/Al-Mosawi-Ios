import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:ahmad_pro/services/network_sensitive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PasswordRecovery extends StatefulWidget {
  @override
  _PasswordRecoveryState createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {
  final _formKey = GlobalKey<FormState>();
  bool verification = true;
  bool changePass = false;
  String email = '';
  bool loading = false;

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
              child: SafeArea(
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  children: [
                    LogoContainar(),
                    SizedBox(height: 40),
                    Text(
                      'استعادة كلمة السر',
                      style: AppTheme.heading.copyWith(
                        fontSize: 15,
                        color: customColor,
                      ),
                    ),
                    Text(
                      "يرجى إدخال البريد الإلكتروني الصحيح",
                      style: AppTheme.subHeading.copyWith(),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.black),
                              validator: (val) =>
                                  val.isEmpty ? emailEror : null,
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              decoration: textFormInputDecoration(
                                prefixIcon: Icons.email,
                                label: 'البريد الإلكتروني',
                              ),
                            ),
                            SizedBox(height: 30),
                            CustomButton(
                              text: 'send',
                              onPress: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });

                                  sentData(
                                    email: email,
                                  );
                                }
                              },
                              // onPress: () {
                              //   // Navigator.of(context).push(
                              //   //   MaterialPageRoute(
                              //   //     builder: (_) => ConfirmPassword(),
                              //   //   ),
                              //   // );
                              // },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  sentData({
    String email,
  }) async {
    try {
      var data;
      data = FormData.fromMap({
        'email': email,
      });

      Dio dio = new Dio();
      Response response = await dio.post(Utils.PasswordReset_URL, data: data);

      if (response.data['status'] == 200) {
        setState(() {
          loading = !loading;
        });
        showMyDialog(
          context: context,
          message: response.data['message'].toString(),
        );
      } else {
        setState(() {
          loading = !loading;
        });
        showMyDialog(
          context: context,
          message: response.data['message'].toString(),
        );
      }

      // Navigator.pop(context);
    } catch (e) {
      print('Cash errrrrrrrrrrrrrrror');
      setState(() {
        loading = !loading;
      });

      print(e);
    }
  }
}
