import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Courses {
  final int id;
  final String name;
  final String status;
  // ignore: non_constant_identifier_names
  final String video_code;
  final String description;
  final String image;
  final String badge;
  var lessons;
  var ratings;
  var totalRating;
  var oldPrice;
  var newPrice;
  final String ios_product_id;

  Courses({
    this.id,
    this.image,
    this.lessons,
    this.badge,
    this.name,
    this.status,
    this.ratings,
    // ignore: non_constant_identifier_names
    this.video_code,
    this.description,
    this.totalRating,
    this.oldPrice,
    this.newPrice,
    this.ios_product_id
  });
}

class CoursesApi {
  static Future<List<Courses>> fetchAllCourses() async {
    List<Courses> listOfCourses = [];
    try {
      var response = await http.get(
        Utils.Courses_URL,
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          Courses courses = Courses(
            id: items['id'],
            image: items['image'],
            name: items['name'],
            description: items['description'],
            video_code: items['video_code'],
            status: items['status'],
            lessons: items['lessons'],
            ratings: items['Ratings'],
            totalRating: items['TotalRating'],
            oldPrice: items['price_old'],
            newPrice: items['price_new'],
            ios_product_id: items['ios_product_id'],
          );
          listOfCourses.add(courses);
        }
      }
    } catch (e) {
      print('Erroro Coursesssssssssssssssss');
      print(e);
    }
    return listOfCourses;
  }

  static Future<String> getVideoMp4Link({var id}) async {
    String link;
    try {
      var response = await http.get(
        'https://player.vimeo.com/video/$id/config',
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var url in jsonData['request']['files']['progressive']) {
          if (url['quality'] == "360p") {
            link = url['url'];
          } else if (url['quality'] == "240p") {
            link = url['url'];
          }
        }

        print('link:$link');
      }
    } catch (e) {
      print(e);
    }
    return link;
  }

  static Future<List<Courses>> fetchAllLearningSection() async {
    List<Courses> listOfCourses = [];
    try {
      var response = await http.get(
        Utils.LearningSection_URL + "/${User.userid}",
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          Courses courses = Courses(
            id: items['id'],
            image: items['image'],
            name: items['name'],
            description: items['description'],
            video_code: items['video_code'],
            status: items['status'],
            lessons: items['lessons'],
            ratings: items['Ratings'],
            totalRating: items['TotalRating'],
            oldPrice: items['price_old'],
            newPrice: items['price_new'],
            ios_product_id: items['ios_product_id'],
          );
          listOfCourses.add(courses);
        }
      }
    } catch (e) {
      print('Erroro Coursesssssssssssssssss');
      print(e);
    }
    return listOfCourses;
  }

  static Future<List<Courses>> fetchMyCourses() async {
    List<Courses> listOfCourses = [];
    try {
      var response = await http.get(
        Utils.MyCourses_URL + '/${User.userid}',
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var items in jsonData['data']) {
          Courses courses = Courses(
            id: items['id'],
            image: items['image'],
            name: items['name'],
            description: items['description'],
            video_code: items['video_code'],
            status: items['status'],
            lessons: items['lessons'],
            ratings: items['Ratings'],
            totalRating: items['TotalRating'],
            oldPrice: items['price_old'],
            newPrice: items['price_new'],
            ios_product_id: items['ios_product_id'],
          );
          listOfCourses.add(courses);
        }
      }
    } catch (e) {
      print('Erroro MyCoursesssssssssssssssss');
      print(e);
    }
    return listOfCourses;
  }

  static Future<Courses> freeCourses() async {
    Courses courses;
    try {
      var response =
          await http.get(Utils.GeneralData_URL + "?user_id=${User.userid}");
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        courses = Courses(
          id: jsonData['data']['HomeFreeCourse']['id'],
          image: jsonData['data']['HomeFreeCourse']['image'],
          name: jsonData['data']['HomeFreeCourse']['name'],
          description: jsonData['data']['HomeFreeCourse']['description'],
          video_code: jsonData['data']['HomeFreeCourse']['video_code'],
          status: jsonData['data']['HomeFreeCourse']['status'],
          lessons: jsonData['data']['HomeFreeCourse']['lessons'],
          ratings: jsonData['data']['HomeFreeCourse']['Ratings'],
          totalRating: jsonData['data']['HomeFreeCourse']['TotalRating'],
          oldPrice: jsonData['data']['HomeFreeCourse']['price_old'],
          newPrice: jsonData['data']['HomeFreeCourse']['price_new'],
          ios_product_id: jsonData['data']['HomeFreeCourse']['ios_product_id'],
        );
      }
    } catch (e) {
      print('Erroro MyCoursesssssssssssssssss');
      print(e);
    }
    return courses;
  }
}
