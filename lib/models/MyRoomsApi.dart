import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ahmad_pro/models/userData.dart';

class MyRooms {
  final int id;
  final String name;

  var chats;

  MyRooms({
    this.id,
    this.chats,
    this.name,
  });
}

class MyRoomsApi {
  static Future<List<MyRooms>> fetchAllMyRooms() async {
    List<MyRooms> listOfMyRooms = [];
    try {
      var response = await http.get(
        Utils.MyRooms_URL + '/${User.userid}',
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          MyRooms myRooms = MyRooms(
            id: items['id'],
            name: items['name'],
            chats: items['Chats'],
          );
          listOfMyRooms.add(myRooms);
        }
      }
    } catch (e) {
      print('Erroro MyRoomsssssssssssssssss');
      print(e);
    }
    return listOfMyRooms;
  }
}
