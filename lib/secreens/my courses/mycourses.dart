import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/couresApi.dart';
import 'package:ahmad_pro/secreens/courses/allCourses.dart';
import 'package:ahmad_pro/secreens/my%20courses/mycoursesdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCourses extends StatefulWidget {
  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'دوراتي',
        ),
      ),
      body: gardViewOfAllCourses(
        context: context,
      ),
    );
  }

  gardViewOfAllCourses({BuildContext context}) {
    return FutureBuilder(
      future: CoursesApi.fetchMyCourses(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return (snapshot.data == null || snapshot.data.isEmpty)
              ? Center(
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => AllCourses()),
                      );
                    },
                    color: customColor,
                    child: Text(
                      'للدورات التدريبة',
                      style: AppTheme.heading.copyWith(color: Colors.white),
                    ),
                  ),
                )
              : GridView.count(
                  crossAxisCount: 2,
                  primary: false,
                  childAspectRatio: .6,
                  shrinkWrap: true,
                  children: List.generate(
                    snapshot.data.length,
                    (index) {
                      return allCoursesCard(
                          courses: snapshot.data[index],
                          context: context,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MyCoursesDetails(
                                  courses: snapshot.data[index],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                );
        } else {
          return Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }

  allCoursesCard({Courses courses, BuildContext context, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: customCachedNetworkImage(
                  context: context,
                  url: courses.image,
                ),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: 200,
              child: Text(
                (courses.name) ?? '',
                style: AppTheme.headingColorBlue.copyWith(fontSize: 12),
              ),
            ),
            SizedBox(height: 5),
            RatingStar(
              rating: double.parse(courses.totalRating.toString()),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                (courses.newPrice == null)
                    ? Container()
                    : Text(
                        '${courses.newPrice}\$',
                        style: AppTheme.headingColorBlue.copyWith(
                          fontSize: 12,
                          color: customColor,
                        ),
                      ),
                SizedBox(width: 5),
                (courses.oldPrice == null)
                    ? Container()
                    : Text(
                        '${courses.oldPrice}\$',
                        style: AppTheme.headingColorBlue.copyWith(
                          fontSize: 10,
                          color: (courses.newPrice == null)
                              ? customColor
                              : Colors.black,
                          decoration: (courses.newPrice == null)
                              ? TextDecoration.none
                              : TextDecoration.lineThrough,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
