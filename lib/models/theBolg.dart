import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TheBolg {
  var id;
  var name;
  final String contant;
  final String description;
  var date;
  var image;

  TheBolg({
    this.name,
    this.description,
    this.contant,
    this.date,
    this.image,
    this.id,
  });
}

List<TheBolg> blogList = [];

class TheBolgApi {
  static Future<List<TheBolg>> fetchAllTheBolg({String type}) async {
    List<TheBolg> listOfTheBolg = [];
    try {
      var response = await http.get(
        Utils.Blog_URL + '?type=$type',
      );
      var jsonData = json.decode(response.body);
      print("items:$jsonData");

      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          TheBolg theBolg = TheBolg(
            id: items['id'],
            description: items['description'],
            image: items['x_featured_media'],
            date: items['date'],
            contant: items['content']['rendered'],
            name: items['title']['rendered'],
          );
          listOfTheBolg.add(theBolg);
        }
      }
    } catch (e) {
      print('Erroro TheBolggggggggggggggg');
      print(e);
    }
    return listOfTheBolg;
  }
}
