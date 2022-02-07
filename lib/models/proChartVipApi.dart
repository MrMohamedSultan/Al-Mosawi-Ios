import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProChartVIPModels {
  final String title;
  final String image;
  final String des;
  final String homeAdImage;
  final String contactUsBanner;
  var features;
  var trading;

  ProChartVIPModels({
    this.homeAdImage,
    this.title,
    this.image,
    this.des,
    this.features,
    this.trading,
    this.contactUsBanner,
  });
}

class ProChartVIPModelsApi {
  static Future<ProChartVIPModels> futchProChartVIP() async {
    ProChartVIPModels aboutUs;
    try {
      var response =
          await http.get(Utils.GeneralData_URL + "?user_id=${User.userid}");
      var jsonData = json.decode(response.body);
      print('response.statusCode:${response.statusCode}');
      if (response.statusCode == 200) {
        aboutUs = ProChartVIPModels(
          title: jsonData['data']['ProChartVIP']['title'],
          image: jsonData['data']['ProChartVIP']['image'],
          des: jsonData['data']['ProChartVIP']['des'],
          features: jsonData['data']['ProChartVIP']['features'],
          homeAdImage: jsonData['data']['HomeAdImage'],
          contactUsBanner: jsonData['data']['contactUsBanner'],
          trading: jsonData['data']['trading']['features'],
        );
      }
    } catch (e) {
      print('AboutUs ProChartVIPModels');
      print(e);
    }
    return aboutUs;
  }
}
