import 'dart:io';

import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/contactUsApi.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ahmad_pro/models/utils.dart';

// import 'package:gx_file_picker/gx_file_picker.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  List<File> listFiles = [];

  String error = '';
  bool loading = false;
  String email;
  String name;
  String phone;
  String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: (loading)
          ? Container(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : ListView(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                firstSections(),
                SizedBox(height: 20),
                Text(
                  'لديك سؤال عن الفوركس أو تريد أن تسأل عن تحليل أو تريد المشاركة معنا؟',
                  style: AppTheme.heading.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                contactUsForm(),
                SizedBox(height: 10),
                (loading)
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        child: CustomButton(
                          onPress: () async {
                            // List<File> res = await FilePicker.getMultiFile(
                            //   type: FileType.any,
                            // );
                            // if (res == null) {
                            //   print('NOOOOOOOOO FILE PICE');
                            // } else {
                            //   listFiles = res;
                            fileDialog(
                              context: context,
                              message: 'تم اضاقه ${listFiles.length} ملفات',
                            );
                            // }
                          },
                          text: 'اضافه ملف / صورة',
                        ),
                      ),
                (loading)
                    ? Text(
                        'جاري ارسال الرساله....',
                        style: AppTheme.subHeading,
                      )
                    : CustomButton(
                        onPress: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = !loading;
                            });

                            sentData(
                              userName: name,
                              user_id: User.userid,
                              message: message,
                              mobile: phone,
                              email: email,
                              files: listFiles,
                              deviceToken: User.userToken,
                            );
                          }
                        },
                        text: 'ارسال',
                      ),
              ],
            ),
    );
  }

  Future<void> fileDialog({BuildContext context, String message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text(
                    (message) ??
                        'تم اضافة الطلب لستكمال عمليه الشراء عليه الذهاب الي عربة التسوق',
                    style: AppTheme.subHeading,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'حسنا',
                style: AppTheme.heading.copyWith(
                  color: customColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'الغاء',
                style: AppTheme.heading.copyWith(
                  color: customColor,
                ),
              ),
              onPressed: () {
                listFiles.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  contactUsForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: textFormInputDecoration(
              label: 'الاسم',
              prefixIcon: Icons.person,
              suffixIcon: Icons.edit,
            ),
            validator: (val) => val.isEmpty ? nameEror : null,
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: textFormInputDecoration(
              label: 'البريد الإلكتروني',
              prefixIcon: Icons.email,
              suffixIcon: Icons.edit,
            ),
            validator: (val) => val.isEmpty ? emailEror : null,
            onChanged: (val) {
              setState(() {
                email = val;
              });
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: textFormInputDecoration(
              label: 'رقم الهاتف',
              prefixIcon: Icons.phone,
              suffixIcon: Icons.edit,
            ),
            validator: (val) => val.isEmpty ? phoneEror : null,
            onChanged: (val) {
              setState(() {
                phone = val;
              });
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            maxLines: null,
            decoration: textFormInputDecoration(
              label: 'رسالتك',
              prefixIcon: Icons.message,
              suffixIcon: Icons.edit,
            ),
            validator: (val) => val.isEmpty ? 'برجاء ادخال رسالتك' : null,
            onChanged: (val) {
              setState(() {
                message = val;
              });
            },
          ),
        ],
      ),
    );
  }

  sentData({
    String userName,
    String email,
    String mobile,
    String message,
    // ignore: non_constant_identifier_names
    int user_id,
    List<File> files,
    String deviceToken,
  }) async {
    print(files.isEmpty);
    try {
      var data;
      // ignore: prefer_is_not_empty
      if (!files.isEmpty) {
        var filesForm = [];
        for (var items in files) {
          filesForm.add(await MultipartFile.fromFile(
            items.path,
            filename: items.path.split('/').last,
          ));
        }

        print('filesForm:$filesForm');

        print('filesForm[0]:${filesForm[0]}');
        data = FormData.fromMap({
          'userName': userName,
          'email': email,
          'mobile': mobile,
          'message': message,
          'user_id': user_id.toString(),
          'DeviceToken': deviceToken,
          "files": filesForm,
        });
      } else {
        print(files.isEmpty);

        data = FormData.fromMap({
          'userName': userName,
          'email': email,
          'mobile': mobile,
          'message': message,
          'user_id': user_id.toString(),
          'DeviceToken': deviceToken,
          "files": [],
        });
      }
      print(data);
      Dio dio = new Dio();
      Response response = await dio.post(Utils.ContactUs_URL, data: data);

      if (response.data['status'] == 'success') {
        print(response.data['message']);
        showMyDialog(
          context: context,
          message: "تم ارسال الرسالة بنجاح",
        );

        setState(() {
          loading = !loading;
        });

        listFiles.clear();
      } else {
        print(response.data['errorArr']);
        showMyDialog(
          context: context,
          message: response.data['errorArr'].toString(),
        );

        setState(() {
          loading = !loading;
        });
      }
      listFiles.clear();
    } catch (e) {
      print('Cash errrrrrrrrrrrrrrror');
      showMyDialog(
        context: context,
        message: "حدث خطا اثناء الارسال يرجي المحاوله مجددا",
      );
      setState(() {
        loading = !loading;
      });

      listFiles.clear();
      print(e);
    }
  }

  firstSections() {
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/ahmed.jpg'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'معلومات الإتصال',
          style: AppTheme.heading,
        ),
        SizedBox(height: 10),
        FutureBuilder(
          future: ContactUsApi.futchContactUs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return (snapshot.data == null)
                  ? Container()
                  : ListView(
                      shrinkWrap: true,
                      primary: false,
                      children: [
                        contactInformation(
                          icon: FontAwesomeIcons.phone,
                          title: snapshot.data.phone,
                        ),
                        SizedBox(height: 10),
                        contactInformation(
                          icon: Icons.email,
                          title: snapshot.data.email,
                        ),
                      ],
                    );
            } else {
              return Center(child: CircularProgressIndicator.adaptive());
            }
          },
        ),
      ],
    );
  }

  contactInformation({String title, IconData icon}) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: Text(
            title,
            style: AppTheme.heading.copyWith(
              fontSize: 10,
              color: customColorGray,
            ),
          ),
        )
      ],
    );
  }
}
