import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyMassege {
  final int id;
  final String date;
  final String content;
  final String status;
  final String title;
  final String name;
  var comments;

  MyMassege({
    this.date,
    this.content,
    this.status,
    this.title,
    this.comments,
    this.id,
    this.name,
  });
}

class MyMessageApi {
  static Future<MyMassege> fetchAllMyMassegeComments(int id) async {
    MyMassege myMassege;
    try {
      var response = await http.get(
        Utils.MyMessages_URL + '/${User.userid}/$id',
      );
      var jsonData = json.decode(response.body);
      print(jsonData);
      print(jsonData['data']['date']);
      if (response.statusCode == 200) {
        myMassege = MyMassege(
          date: jsonData['data']['date'],
          id: jsonData['data']['messageID'],
          content: jsonData['data']['content'],
          title: jsonData['data']['title'],
          name: jsonData['data']['name'],
          status: jsonData['data']['status'],
          comments: jsonData['data']['comments'],
        );
      }
    } catch (e) {
      print('Erroro MYMessage');
      print(e);
    }
    return myMassege;
  }

  static Future<List<MyMassege>> fetchAllMyMassege() async {
    List<MyMassege> listOfMyMassege = [];
    try {
      var response = await http.get(
        Utils.MyMessages_URL + '/${User.userid}',
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          MyMassege myMassege = MyMassege(
            date: items['date'],
            id: items['messageID'],
            content: items['content'],
            title: items['title'],
            name: items['name'],
            status: items['status'],
            comments: items['comments'],
          );
          listOfMyMassege.add(myMassege);
        }
      }
    } catch (e) {
      print('Erroro MYMessage');
      print(e);
    }
    return listOfMyMassege;
  }
}
