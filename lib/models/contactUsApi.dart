import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContatUsModels {
  final String email;
  final String phone;
  final String whatsApp;
  final String acceptedPaymentMethod;
  final String videoFeaturesBg;
  var parteners;
  var acountFeatures;

  ContatUsModels({
    this.email,
    this.phone,
    this.parteners,
    this.acceptedPaymentMethod,
    this.videoFeaturesBg,
    this.whatsApp,
    this.acountFeatures,
  });
}

class ContactUsApi {
  static Future<ContatUsModels> futchContactUs() async {
    ContatUsModels contactUs;
    try {
      var response =
          await http.get(Utils.GeneralData_URL + "?user_id=${User.userid}");
      var jsonData = json.decode(response.body);
      print('response.statusCode:${response.statusCode}');

      if (response.statusCode == 200) {
        contactUs = ContatUsModels(
          email: jsonData['data']['email'],
          phone: jsonData['data']['phone'],
          whatsApp: jsonData['data']['whatsApp'],
          parteners: jsonData['data']['Parteners'],
          acountFeatures: jsonData['data']['acountFeatures'],
          acceptedPaymentMethod: jsonData['data']['acceptedPaymentMethod'],
          videoFeaturesBg: jsonData['data']['videoFeaturesBg'],
        );
      }
    } catch (e) {
      print('contatus Errrrrrrrrror');
      print(e);
    }
    return contactUs;
  }
}
