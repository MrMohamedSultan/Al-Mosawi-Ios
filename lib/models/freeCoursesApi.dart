import 'dart:developer';

import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../sharedPreferences.dart';

import 'dart:convert';

import 'package:equatable/equatable.dart';

class FreeCourses {
  final int id;
  final String status;
  final String message;



  FreeCourses(
      {this.id, this.status, this.message,});
}

class FreeCoursesApi {
  static Future<List<FreeCourses>> fetchFreeCourses( int courseId) async {
    final id = await MySharedPreferences.getUserUserid();
    List<FreeCourses> listOfMyFreeCourses = [];
    try {
      var response = await http.post(
          Utils.FreeCourses_URL , body: {
        'user_id': id,
        'course_id': courseId.toString(),
      }

      );
      log(response.body);
      // var jsonData = json.decode(response.body);
      // if (response.statusCode == 200) {
      //   for (var items in jsonData['data']) {
      //     FreeCourses freeCourses = FreeCourses(
      //       id: items['id'],
      //       status: items['status'],
      //       message: items['message'],
      //
      //     );
      //     listOfMyFreeCourses.add(freeCourses);
      //   }
      // }
      print(" --------------  Success free free courses  ------------------- ");
    } catch (e,st) {
      print('********************** Error from Free Courses request *****************************');
      print(e.toString());
      print(st.toString());
    }
    return listOfMyFreeCourses;
  }
}

Future<void> catchFreeCourseApi(int courseId)async {
  try{
    final res = await Dio().post( Utils.FreeCourses_URL
        ,data: {
          'user_id': await MySharedPreferences.getUserUserid(),
          'course_id': courseId.toString(),
        });
print(res.data.toString());
  }catch(e ,st){
    log(e);
    log(st.toString());
  }
}


class CourseFree extends Equatable {
  final String id;
  final String message;

  CourseFree({
    @required this.id,
    @required this.message,

  });

  CourseFree copyWith({
    String id,
    String message,

  }) {
    return CourseFree(
      id: id ?? this.id,
      message: message ?? this.message,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,

    };
  }

  factory CourseFree.fromMap(Map<String, dynamic> map) {
    return CourseFree(
      id: map['id'] ?? '',
      message: map['message'] ?? '',

    );
  }

  String toJson() => json.encode(toMap());

  factory CourseFree.fromJson(String source) => CourseFree.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Data(id: $id,  message: $message)';
  }

  @override
  List<Object> get props => [id, message, ];
}

