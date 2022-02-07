import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/secreens/cart/cart.dart';

import 'package:ahmad_pro/secreens/wrapper/wrapper.dart';
import 'package:ahmad_pro/services/dbhelper.dart';
import 'package:ahmad_pro/services/homeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../sharedPreferences.dart';

class CheckOut extends StatefulWidget {
  final String totalPrice;

  final AsyncSnapshot data;

  const CheckOut({
    Key key,
    this.totalPrice,
    this.data,
  }) : super(key: key);
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DbHehper helper;
  bool loading = false;
  @override
  void initState() {
    helper = DbHehper();
    super.initState();
  }

  int id = 0;
  String token =
      "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";
  String paymentToken =
      "UXHBd3FzJmSSkBzAPfSRbTAHeKG7zYdvyivO6idxFbuHZ5Pctpi-1s8ahlHVqeol7fYgTx2Goqln2Jp6tw_PrPDbNLGp7KYXAWLGpsk3CAxDg2-pMIX7CbH4sQo2DWOXNA8MdbYEx0kY5wPIQCfjIRLZfbpLiSmSU2UIsNy9--ICRm_WNci8AK-PGYGEYlu0SoHOG_EGjwRAALvsnbSpKtfdkzrAaZyA6QfJ8XzYHhvK2ARwJj_EkDBPwgrobtDNd3jlvN9QOp8jJuaw087DElcmxiIk6vsva_1o_U8Ji40XDJ35p5S4AGePVqxRKIjwDd5fgtj-uJDDRAWSyCXPeq3CFnAEWGsjiNK5P1bKXVdgR-GT3vCMA5RxiSnqcFwe2lfmrYPEhadRPr4cpRtmhPMqhkwIvG7IK3QioNGczImhAYmuUk8w3F3dJFWxQfeJUXLdQv2yKgKwQCXm-6RPbSbCtoWKjaqwzyAQuCm7OuB-kX5qfFh4RRUKiiaPDHtzQmL8Y7QzQJyR49l-eLroaerAyQLPLZPnpA_Et_tKz9cVear3pXtuHl4F7fdJM4w5GHVZ4HLaju6ZEYLDPmjR9EE7QbXVcBx4HyIxe0gtY-zHnWWciOxa3lTkr3fct3AzrYB46AfFDeZmEWiCYOCwPfhCydx_gVEf4lgKb0htX3R4gv-VRFG5bEhcJbIcaKSBne-LGA";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: customColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'الدفع',
          style: AppTheme.heading.copyWith(color: Colors.white),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return MyFatoorah(
            request: MyfatoorahRequest(
              url: "https://apitest.myfatoorah.com",
              token: token,
              currencyIso: Country.UAE,
              successUrl:
                  "https://assets.materialup.com/uploads/473ef52c-8b96-46f7-9771-cac4b112ae28/preview.png",
              errorUrl:
                  "https://www.digitalpaymentguru.com/wp-content/uploads/2019/08/Transaction-Failed.png",
              invoiceAmount: Cart.totalPraices,
              language: ApiLanguage.Arabic,
            ),
            errorChild: Center(
              child: Icon(
                Icons.error,
                color: Colors.redAccent,
                size: 50,
              ),
            ),
            succcessChild: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.done_all,
                    color: Colors.greenAccent,
                    size: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'لاستكمال عمليه الشراء يجب الضغط علي زر العوده بالاعلي',
                      style: AppTheme.heading,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            onResult: (PaymentResponse res) {
              print("res.status:${res.status}");
              if (res.status == PaymentStatus.Success) {
                checkOut(item: widget.data, paymentData: res.status);
              } else {
                checkOutDialog(
                  context: context,
                  message: 'فشل يرجي المحاوله مجددا في وقت لاحق',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Cart(),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
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

  checkOut({var item, var paymentData}) async {
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
    print('courses:$courses');
    print('plans:$plans');

    try {
      print('User.userid:${User.userid}');

      var body = {
        'user_id': User.userid,
        'courses': courses,
        'plans': plans,
        'total': Cart.totalPraices.toString(),
        'payment_data': paymentData.toString(),
        'success': "success",
      };
      print(body);

      var response = await http.post(
        Utils.SubmitCartItems_URL,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      var jsonData = json.decode(response.body);
      print("jsonData:::$jsonData");

      if (jsonData['status'] == 'success') {
        await helper.deleteAllProduct();
        decreaseCartTotlaPrice(
          price: Cart.totalPraices,
        );
        setState(() {
          MySharedPreferences.saveUserPayPlan(false);
        });
        checkUserSubscriptions();
        checkOutDialog(
          context: context,
          message: jsonData['message'].toString(),
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => Wrapper(),
              ),
            );
          },
        );
      } else if (jsonData['status'] == 'error') {
        setState(() {
          loading = !loading;
        });
        checkOutDialog(
          context: context,
          message: jsonData['message'].toString(),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => Cart(),
              ),
            );
          },
        );
      } else {
        checkOutDialog(
          context: context,
          message: jsonData['errorArr'].toString(),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => Cart(),
              ),
            );
          },
        );
      }
    } catch (e) {
      print('Cash carrrrrrrrt');
      checkOutDialog(
        context: context,
        message: 'حدث خطأ ما, يرجي التواصل مع الدعم الفني',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Cart(),
            ),
          );
        },
      );
      setState(() {});

      print(e);
    }
  }

  Future<void> checkOutDialog(
      {BuildContext context, String message, Function onTap}) async {
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
                    'رساله اداريه',
                    style: AppTheme.heading.copyWith(
                      color: customColor,
                    ),
                  ),
                ),
                Text(
                  message,
                  style: AppTheme.subHeading,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'تم',
                style: AppTheme.heading.copyWith(
                  color: customColor,
                ),
              ),
              onPressed: onTap,
            ),
          ],
        );
      },
    );
  }
}
