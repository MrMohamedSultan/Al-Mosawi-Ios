import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoProChart {
  final int id;
  final String title;
  final String videoCode;
  final String description;
  final String image;

  VideoProChart({
    this.id,
    this.image,
    this.title,
    this.description,
    this.videoCode,
  });
}

class VideoProchartApi {
  static Future<List<VideoProChart>> fetchAllVideoProChart() async {
    List<VideoProChart> listOfVideoProChart = [];
    try {
      var response = await http.get(
        Utils.VideosProChart_URL,
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          VideoProChart videoProChart = VideoProChart(
            id: items['id'],
            image: items['image'],
            title: items['title'],
            description: items['description'],
            videoCode: items['VideoCode'],
          );
          listOfVideoProChart.add(videoProChart);
        }
      }
    } catch (e) {
      print('Erroro Coursesssssssssssssssss');
      print(e);
    }
    return listOfVideoProChart;
  }
}
