import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/couresApi.dart';
import 'package:ahmad_pro/secreens/courses/coursesDetailes.dart';
import 'package:ahmad_pro/services/dbhelper.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  DbHehper helper;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    helper = DbHehper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'جميع الدورات',
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            customOnRefresh(onRefresh: () {
              setState(() {
                loading = !loading;
              });
            }, affterRefresh: () {
              setState(() {
                loading = !loading;
              });
            });
          },
          child: (loading)
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  primary: true,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  children: [
                    SizedBox(height: 20),
                    gardViewOfAllCourses(
                      context: context,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  gardViewOfAllCourses({BuildContext context}) {
    return FutureBuilder(
      future: CoursesApi.fetchAllCourses(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return (snapshot.data == null || snapshot.data.isEmpty)
              ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لا يوجد بينات حاليا /',
                        style: AppTheme.heading,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'اسحب الشاشه لاسفل لاعاده التحميل',
                        style: AppTheme.heading,
                        textAlign: TextAlign.center,
                      ),
                    ],
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
                                builder: (_) => Coursesedtails(
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
              height: 50,
              child: Text(
                courses.name,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: customColor,
                        ),
                      ),
                SizedBox(width: 5),
                Text(
                  (courses.oldPrice == null)
                      ? Container()
                      : (courses.oldPrice != '0')
                          ? '${courses.oldPrice}\$'
                          : "مجاناً",
                  style: AppTheme.headingColorBlue.copyWith(
                    fontSize: (courses.newPrice == null) ? 14 : 12,
                    fontWeight: FontWeight.w700,
                    color:
                        (courses.newPrice == null) ? customColor : Colors.black,
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
