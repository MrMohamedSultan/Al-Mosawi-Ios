import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/prodact.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/secreens/checkOut/checkOut.dart';
import 'package:ahmad_pro/secreens/wrapper/wrapper.dart';
import 'package:ahmad_pro/services/dbhelper.dart';
import 'package:ahmad_pro/services/homeProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../sharedPreferences.dart';

class Cart extends StatefulWidget {
  static List<ConsultantProdect> consultProdect = [];
  static double totalPraices = 0.0;

  static SharedPreferences sharedPreferences;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DbHehper helper;
  getTotalPrice() async {
    Cart.totalPraices = await MySharedPreferences.getTotalPrice();
    User.userBuyPlan = await MySharedPreferences.getUserBuyPlan();
  }

  @override
  void initState() {
    helper = DbHehper();
    getTotalPrice();
    super.initState();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        title: Text('عربة التسوق'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => Wrapper()),
              (route) => false,
            );
          },
        ),
      ),
      body: (loading)
          ? Container(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : FutureBuilder(
              future: helper.allProduct(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return (snapshot.data.isEmpty)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.shoppingCart,
                                color: customColor,
                                size: 100,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'السله فارغه',
                                style: AppTheme.heading,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: snapshot.data.length,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Card(
                                  elevation: 3,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              'الاسم: ',
                                              style: AppTheme.heading.copyWith(
                                                color: customColor,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[index]['title'],
                                              style:
                                                  AppTheme.subHeading.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'السعر: ',
                                                  style:
                                                      AppTheme.heading.copyWith(
                                                    color: customColor,
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data[index]['price']
                                                      .toString(),
                                                  style: AppTheme.subHeading
                                                      .copyWith(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Icon(
                                                  FontAwesomeIcons.poundSign,
                                                  color: Colors.black,
                                                  size: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            size: 30,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              setState(() {
                                                if (snapshot.data[index]
                                                        ['type'] ==
                                                    'plan') {
                                                  setState(() {
                                                    MySharedPreferences
                                                        .saveUserPayPlan(false);
                                                  });
                                                }
                                              });
                                            });
                                            await helper.deleteProduct(
                                                snapshot.data[index]['id']);
                                            decreaseCartTotlaPrice(
                                              price: snapshot.data[index]
                                                  ['price'],
                                            );
                                          },
                                        ),
                                        leading: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: customCachedNetworkImage(
                                            context: context,
                                            url: snapshot.data[index]
                                                ["proImageUrl"],
                                          ),
                                        ),
                                      ),

                                      // productDate(snapshot, index),
                                    ],
                                  ),
                                ),
                                (index == snapshot.data.length - 1)
                                    ? totalPrieCard(
                                        context: context,
                                        data: snapshot,
                                      )
                                    : Container(),
                              ],
                            );
                          },
                        );
                }
              },
            ),
    );
  }

  Container totalPrieCard({
    BuildContext context,
    AsyncSnapshot data,
  }) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: customColor),
        ),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'السعر الكلي: ',
                    style: AppTheme.subHeading.copyWith(),
                  ),
                  Text(
                    Cart.totalPraices.toStringAsFixed(2),
                    style: AppTheme.subHeading.copyWith(
                      color: customColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                // ignore: deprecated_member_use
                child: FlatButton.icon(
                  color: customColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (Cart.totalPraices == 0.0) {
                      checkOut(item: data);
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CheckOut(
                            totalPrice: Cart.totalPraices.toString(),
                            data: data,
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    FontAwesomeIcons.moneyCheckAlt,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    'الدفع',
                    style: AppTheme.subHeading.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkOut({var item}) async {
    String courses = '';
    String plans = '';
    for (var items in item.data) {
      switch (items['type']) {
        case 'course':
          courses = courses + '${items['consultantId']},';
          break;
        default:
          plans = plans + '${items['consultantId']},';
      }
    }
    courses =
        courses.length > 0 ? courses.substring(0, courses.length - 1) : '';
    plans = plans.length > 0 ? plans.substring(0, plans.length - 1) : '';

    try {
      var body = {
        'user_id': User.userid.toString(),
        'courses': courses,
        'plans': plans,
        'total': Cart.totalPraices.toString(),
        'payment_data': null,
        'success': "success",
      };

      var response = await http.post(
        Utils.SubmitCartItems_URL,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success') {
        setState(() {
          loading = !loading;
        });
        setState(() {
          MySharedPreferences.saveUserPayPlan(false);
        });
        await helper.deleteAllProduct();
        decreaseCartTotlaPrice(
          price: Cart.totalPraices,
        );
        checkUserSubscriptions();
        showMyDialog(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => Wrapper(),
              ),
            );
          },
          context: context,
          message: jsonData['message'].toString(),
        );
      } else if (jsonData['status'] == 'error') {
        setState(() {
          loading = !loading;
        });
        showMyDialog(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => Wrapper(),
              ),
            );
          },
          context: context,
          message: jsonData['message'].toString(),
        );
      } else {
        setState(() {
          loading = !loading;
        });
        showMyDialog(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => Wrapper(),
              ),
            );
          },
          context: context,
          message: jsonData['errorArr'].toString(),
        );
      }
    } catch (e) {
      showMyDialog(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => Wrapper(),
            ),
          );
        },
        context: context,
        message: "حدث خطا اثناء الارسال يرجي المحاوله مجددا",
      );
      setState(() {
        loading = !loading;
      });

      print(e);
    }
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
}
