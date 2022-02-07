import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyplanModels {
  final int id;
  final String status;
  final String fromDate;
  final String toDate;
  final String planName;

  MyplanModels(
      {this.id, this.status, this.toDate, this.fromDate, this.planName});
}

class MyPlansApi {
  static Future<List<MyplanModels>> fetchMyPlans() async {
    List<MyplanModels> listOfMyplanModels = [];
    try {
      var response = await http.post(Utils.MyPlans_URL, body: {
        'user_id': User.userid.toString(),
      });
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          MyplanModels plan = MyplanModels(
            id: items['id'],
            status: items['status'],
            fromDate: items['fromDate'],
            toDate: items['toDate'],
            planName: items['planName'],
          );
          listOfMyplanModels.add(plan);
        }
      }
    } catch (e) {
      print('Erroro MyMyplanModelsssssssssssssssss');
      print(e);
    }
    return listOfMyplanModels;
  }
}
