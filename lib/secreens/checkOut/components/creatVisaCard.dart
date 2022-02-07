import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/prodact.dart';
import 'package:ahmad_pro/models/visaCard.dart';
import 'package:ahmad_pro/secreens/checkOut/checkOut.dart';
import 'package:ahmad_pro/secreens/wrapper/wrapper.dart';
import 'package:ahmad_pro/services/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddFileBottomSheet extends StatefulWidget {
  @override
  _AddFileBottomSheetState createState() => _AddFileBottomSheetState();
}

class _AddFileBottomSheetState extends State<AddFileBottomSheet> {
  int id;
  DbHehper helper;
  String type;
  String cVVNumber;
  String visaNamber;
  String exDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    helper = DbHehper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        children: [
          Center(
            child: Text(
              'طريقه الدفع',
              style: AppTheme.heading.copyWith(
                color: customColor,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        groupValue: id,
                        value: 0,
                        title: Icon(
                          FontAwesomeIcons.ccVisa,
                          color: Colors.blue,
                        ),
                        onChanged: (val) {
                          setState(() {
                            id = val;
                            type = 'visa';
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        groupValue: id,
                        value: 1,
                        title: Icon(
                          FontAwesomeIcons.ccMastercard,
                          color: Colors.blue,
                        ),
                        onChanged: (val) {
                          setState(() {
                            id = val;
                            type = 'mastercard';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: conectedTextFormStyle(lableText: 'رقم البطاقه '),
                  validator: (val) =>
                      val.isEmpty ? 'يجب ادخال رقم البطاقه' : null,
                  onChanged: (val) {
                    setState(() {
                      visaNamber = val;
                    });
                  },
                ),
                SizedBox(height: 25),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: conectedTextFormStyle(lableText: 'CVV'),
                  validator: (val) => val.isEmpty ? 'يجب ادخال رقم Cvv' : null,
                  onChanged: (val) {
                    setState(() {
                      cVVNumber = val;
                    });
                  },
                ),
                SizedBox(height: 25),
                InkWell(
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: new DateTime(1900),
                      onChanged: (date) {
                        print('change $date in time zone ' +
                            date.timeZoneOffset.inHours.toString());
                      },
                      onConfirm: (date) {
                        setState(() {
                          Helper.chossenDate = "${date.month}/${date.year}";
                          exDate = Helper.chossenDate;
                        });
                      },
                      currentTime: DateTime.now(),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(color: customColor),
                    ),
                    child: Text(
                      (Helper.chossenDate == '')
                          ? 'تاريخ الانتهاء'
                          : Helper.chossenDate,
                      style: AppTheme.heading.copyWith(
                        color: customColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                CustomButtonWithchild(
                  color: customColor,
                  onPress: () async {
                    if (id != null && exDate != null) {
                      if (_formKey.currentState.validate()) {
                        CustomVisa visa = CustomVisa({
                          'type': type,
                          'cvvNumber': cVVNumber,
                          'exDate': exDate,
                          'visaNumber': visaNamber,
                        });
                        await helper.createvisa(visa);
                        setState(() {
                          Helper.chossenDate = '';
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => CheckOut()),
                          ModalRoute.withName(Wrapper.route),
                        );
                      }
                    } else {
                      showMyDialog(
                        context: context,
                        message: 'يجب استكمال البينات اولا ',
                      );
                    }
                  },
                  child: Text(
                    'حفظ',
                    style: AppTheme.heading.copyWith(color: Colors.white),
                  ),
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
