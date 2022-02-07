import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CoursesFillter extends StatefulWidget {
  final String title;

  const CoursesFillter({Key key, @required this.title}) : super(key: key);
  @override
  _CoursesFillterState createState() => _CoursesFillterState();
}

class _CoursesFillterState extends State<CoursesFillter> {
  List<String> fillterList = [
    'Recent',
    'HD Certified',
    'Price Low to High',
    'Price High to low',
    'Rate',
  ];
  int filtterTapped;
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      primary: true,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.grey[500]),
                  onPressed: () {},
                ),
                Text(
                  'Seach by',
                  style: AppTheme.heading.copyWith(color: Colors.grey[500]),
                ),
              ],
            ),
            Transform.rotate(
              angle: 180 * 3.14 / 365,
              child: SvgPicture.asset(
                "assets/icons/filter.svg",
                color: customColor,
                height: 25,
              ),
            ),
          ],
        ),
        SizedBox(height: 40),
        ListView.builder(
          itemCount: fillterList.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      filtterTapped = index;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fillterList[index],
                        style: AppTheme.heading.copyWith(
                          color: (filtterTapped == index)
                              ? Colors.black
                              : Colors.grey[500],
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (filtterTapped == index)
                              ? customColor
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: (filtterTapped == index)
                                ? Colors.white
                                : Colors.transparent,
                            size: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: customColorDivider,
                  thickness: 2,
                ),
                SizedBox(height: 10),
              ],
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: CustomButtonWithchild(
            color: customColor,
            onPress: () {
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(
              //       builder: (BuildContext context) => CoursesPage(
              //             title: widget.title,
              //           )),
              //   ModalRoute.withName('/'),
              // );
            },
            child: Center(
              child: Text(
                'Search',
                style: AppTheme.heading.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
