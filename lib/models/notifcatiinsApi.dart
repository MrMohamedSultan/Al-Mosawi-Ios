import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NitfcationsModels {
  final text;
  final date;

  NitfcationsModels({this.text, this.date});
}

class MyNtifcationsApi {
  static Future<List<NitfcationsModels>> fetchNotifcations() async {
    List<NitfcationsModels> listOfNitfcationsModels = [];
    try {
      var response = await http.post(Utils.MyNotifications_URL, body: {
        'user_id': User.userid.toString(),
      });
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          NitfcationsModels plan = NitfcationsModels(
            text: items['data']['txt'],
            date: items['created_at'],
          );
          listOfNitfcationsModels.add(plan);
        }
      }
    } catch (e) {
      print('Erroro MyNitfcationsModelsssssssssssssssss');
      print(e);
    }
    return listOfNitfcationsModels;
  }
}
