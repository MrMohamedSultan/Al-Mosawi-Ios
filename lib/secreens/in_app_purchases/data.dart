import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:in_app_purchase/in_app_purchase.dart';

class PurchasedModels {
  final int id;
  final String productId;
  PurchasedModels({@required this.id, this.productId,});
}

class PurchasedApi {
  static Future<List<PurchasedModels>> fetchPurchases(String productId) async {
    List<PurchasedModels> listOfPurchasedModels = [];
    try {
      var response = await http.post(Utils.PurchasedEndPoint, body: {
        'user_id': User.userid.toString(),
        'product_id': productId
      });
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          PurchasedModels purchase = PurchasedModels(
            id: items['id'],
          );
          listOfPurchasedModels.add(purchase);
        }
        if (response != null) {
          kShowToast(mes: "تمت عملية الدفع بنجاح");
          //fpop();
          //Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print('Purchased Process Failed  ');
      print(e);
    }
    return listOfPurchasedModels;
  }
}

// Future<mgeneral?> makeServicePaymentDone(PurchaseDetails md) async {
//   final result = await API().connect<APISimple>(
//       kUrls.post_pay, () => APISimple(create: () => mgeneral()),
//       parms: {
//         "ProductId": md.productID,
//         "TransactionId": md.purchaseID,
//       });
//   // df.write(
//   //   kys.ispaid.s,
//   //   true,
//   // );
//   if (result != null) {
//     //kshowMagToast("تمت عملية الدفع بنجاح");
//     kshowToast(mes: "تمت عملية الدفع بنجاح");
//     //fpop();
//     Navigator.of(context).pop();
//   }
// }

kShowToast({String mes}) {
  return Fluttertoast.showToast(
      msg: mes,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.black,
      fontSize: 16.0);
}
