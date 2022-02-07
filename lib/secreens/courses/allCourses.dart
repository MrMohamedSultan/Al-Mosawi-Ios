import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/couresApi.dart';
import 'package:ahmad_pro/secreens/cart/cart.dart';
import 'package:ahmad_pro/secreens/courses/coursesDetailes.dart';
import 'package:ahmad_pro/secreens/in_app_purchases/purchases_integrtions.dart';
import 'package:ahmad_pro/secreens/wrapper/wrapper.dart';
import 'package:ahmad_pro/services/dbhelper.dart';
import 'package:flutter/material.dart';

class AllCourses extends StatefulWidget {
  @override
  _AllCoursesState createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {
  DbHehper helper;
  @override
  void initState() {
    super.initState();
    helper = DbHehper();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'جميع الدورات',
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        primary: true,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          gardViewOfAllCourses(
            context: context,
          ),
        ],
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
                                builder: (_) =>
                                 Coursesedtails(courses: snapshot.data[index],),
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

Future<void> showCartDialog({BuildContext context}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(
                child: Text(
                  'تم اضافة الطلب لستكمال عمليه الشراء عليه الذهاب الي عربة التسوق',
                  style: AppTheme.subHeading,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'الصفحة الرائسية',
              style: AppTheme.heading.copyWith(
                color: customColor,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Wrapper()),
                (route) => false,
              );
            },
          ),
          TextButton(
            child: Text(
              'عربة التسوق',
              style: AppTheme.heading.copyWith(
                color: customColor,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => Cart(),
                ),
                ModalRoute.withName('/'),
              );
            },
          ),
        ],
      );
    },
  );
}
