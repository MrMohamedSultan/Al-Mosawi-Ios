import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomheVideoModels {
  final String homeVideo;
  final String homeVideoTitle;
  final String homeVideoTxt1;
  final String homeVideoTxt2;
  final String homeVideoTxt3;
  final String videoFeaturesBg;
  final String homeProChartSectionImage;
  final String homeProChartSectionTitle;
  final String homeProChartSectionTxt;
  final String homeYourDealSectionTitle;
  final String homeYourDealSectionTxt;
  final String homeYourDealSectionImage;
  var homeNumbers;

  HomheVideoModels({
    this.homeProChartSectionImage,
    this.homeProChartSectionTitle,
    this.homeProChartSectionTxt,
    this.homeYourDealSectionTitle,
    this.homeYourDealSectionImage,
    this.homeYourDealSectionTxt,
    this.homeVideo,
    this.homeVideoTitle,
    this.homeVideoTxt1,
    this.homeVideoTxt2,
    this.homeVideoTxt3,
    this.videoFeaturesBg,
    this.homeNumbers,
  });
}

class HomeVideoApi {
  static Future<HomheVideoModels> futchHomeVideo() async {
    HomheVideoModels aboutUs;
    try {
      var response =
          await http.get(Utils.GeneralData_URL + "?user_id=${User.userid}");
      var jsonData = json.decode(response.body);
      print('response.statusCode:${response.statusCode}');
      if (response.statusCode == 200) {
        aboutUs = HomheVideoModels(
          homeVideo: jsonData['data']['HomeVideo'],
          homeProChartSectionImage: jsonData['data']
              ['homeProChartSectionImage'],
          homeProChartSectionTitle: jsonData['data']
              ['homeProChartSectionTitle'],
          homeYourDealSectionTitle: jsonData['data']
              ['homeYourDealSectionTitle'],
          homeYourDealSectionTxt: jsonData['data']['homeYourDealSectionTxt'],
          homeYourDealSectionImage: jsonData['data']
              ['homeYourDealSectionImage'],
          homeProChartSectionTxt: jsonData['data']['homeProChartSectionTxt'],
          homeVideoTitle: jsonData['data']['HomeVideoTitle'],
          homeVideoTxt1: jsonData['data']['HomeVideoTxt1'],
          homeVideoTxt2: jsonData['data']['HomeVideoTxt2'],
          homeVideoTxt3: jsonData['data']['HomeVideoTxt3'],
          videoFeaturesBg: jsonData['data']['videoFeaturesBg'],
          homeNumbers: jsonData['data']['homeNumbers'],
        );
      }
    } catch (e) {
      print('HomeVideo Errrrrrrrrror');
      print(e);
    }
    return aboutUs;
  }
}
