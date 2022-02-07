import 'dart:io';

import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/proChartVipApi.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ahmad_pro/models/contactUsApi.dart';

// import 'package:gx_file_picker/gx_file_picker.dart';

class TradingAccount extends StatefulWidget {
  @override
  _TradingAccountState createState() => _TradingAccountState();
}

class _TradingAccountState extends State<TradingAccount> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  List<File> listFiles = [];

  String name;
  String country;
  String whatsApp;
  String email;
  String amount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'فتح حساب تداول ',
        ),
      ),
      body: (loading)
          ? Container(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : ListView(
              shrinkWrap: true,
              primary: true,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              children: [
                FutureBuilder(
                  future: ProChartVIPModelsApi.futchProChartVIP(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      return (snapshot.data == null)
                          ? Container()
                          : ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: snapshot.data.trading.length,
                              itemBuilder: (context, index) {
                                return tradingAccountRow(
                                  contant: snapshot.data.trading[index]['text'],
                                  name: snapshot.data.trading[index]['title'],
                                  icon: snapshot.data.trading[index]['image'],
                                  index: index + 1,
                                );
                              },
                            );
                    } else {
                      return Center(child: CircularProgressIndicator.adaptive());
                    }
                  },
                ),
                FutureBuilder(
                  future: ContactUsApi.futchContactUs(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return (snapshot.data == null)
                          ? Container()
                          : (snapshot.data.acceptedPaymentMethod == '' ||
                                  snapshot.data.acceptedPaymentMethod == null)
                              ? Container()
                              : Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  child: customCachedNetworkImage(
                                    context: context,
                                    url: snapshot.data.acceptedPaymentMethod,
                                  ),
                                );
                    } else {
                      return Center(child: CircularProgressIndicator.adaptive());
                    }
                  },
                ),
                SizedBox(height: 10),
                Form(
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
                          label: 'الدوله',
                          prefixIcon: FontAwesomeIcons.globe,
                          suffixIcon: Icons.edit,
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'براجاء ادخال اسم الدوله' : null,
                        onChanged: (val) {
                          setState(() {
                            country = val;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: textFormInputDecoration(
                          label: 'رقم الواتس',
                          prefixIcon: FontAwesomeIcons.whatsapp,
                          suffixIcon: Icons.edit,
                        ),
                        validator: (val) => val.isEmpty ? phoneEror : null,
                        onChanged: (val) {
                          setState(() {
                            whatsApp = val;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
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
                        keyboardType: TextInputType.number,
                        decoration: textFormInputDecoration(
                          label: 'مبلغ الاستثمار',
                          prefixIcon: FontAwesomeIcons.dollarSign,
                          suffixIcon: Icons.edit,
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'برجاء ادخال مبلغ الاسثمار' : null,
                        onChanged: (val) {
                          setState(() {
                            amount = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'الرجاء رفع الاوراق المطلوبه \n( البطاقه المدنيه من الامام والخلف + صوره الجواز )',
                  textAlign: TextAlign.center,
                  style: AppTheme.subHeading,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: CustomButton(
                    onPress: () async {
                      // List<File> res = await FilePicker.getMultiFile(
                      //   type: FileType.any,
                      // );
                      // if (res == null) {
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: CustomButton(
                    onPress: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          loading = !loading;
                        });

                        sentData(
                          name: name,
                          country: country,
                          whatsApp: whatsApp,
                          amount: amount,
                          email: email,
                          files: listFiles,
                        );
                      }
                    },
                    text: 'ارسال',
                  ),
                )
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

  sentData({
    String name,
    String email,
    String whatsApp,
    String country,
    // ignore: non_constant_identifier_names

    List<File> files,
    String amount,
  }) async {
    try {
      var data;
      if (files != null) {
        var filesForm = [];
        for (var items in files) {
          filesForm.add(await MultipartFile.fromFile(
            items.path,
            filename: items.path.split('/').last,
          ));
        }
        data = FormData.fromMap({
          'name': name,
          'email': email,
          'whatsApp': whatsApp,
          'country': country,
          'amount': amount,
          "files": filesForm,
        });
      } else {
        data = FormData.fromMap({
          'name': name,
          'email': email,
          'whatsApp': whatsApp,
          'country': country,
          'amount': amount,
          "files": [],
        });
      }

      Dio dio = new Dio();
      Response response =
          await dio.post(Utils.OpenTradingAccount_URL, data: data);

      if (response.data['status'] == 'success') {
        setState(() {
          loading = !loading;
        });
        showMyDialog(
          context: context,
          message: response.data['message'].toString(),
        );
        listFiles.clear();
      } else {
        setState(() {
          loading = !loading;
        });
        showMyDialog(
          context: context,
          message: response.data['errorArr'].toString(),
        );
        listFiles.clear();
      }

      // Navigator.pop(context);
    } catch (e) {
      print('Cash errrrrrrrrrrrrrrror');
      setState(() {
        loading = !loading;
      });
      listFiles.clear();

      print(e);
    }
  }

  tradingAccountRow({String name, String contant, String icon, int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              index.toString(),
              style: AppTheme.heading,
            ),
            SizedBox(width: 10),
            Container(
              width: 1,
              height: 30,
              color: customColorGray.withOpacity(.5),
            ),
            SizedBox(width: 10),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(icon),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              name,
              style: AppTheme.heading,
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          contant,
          style: AppTheme.subHeading.copyWith(
            color: customColorGray,
            fontSize: 10,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Divider(
            color: customColor.withOpacity(.5),
            thickness: 2,
          ),
        ),
      ],
    );
  }
}
