import 'dart:async';

import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/MyRoomsApi.dart';
import 'package:ahmad_pro/models/homeTapsModels.dart';
import 'package:ahmad_pro/models/proChartVipApi.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/models/visitorHomeIconsApi.dart';
import 'package:ahmad_pro/secreens/LearningSection/LearningSection.dart';
import 'package:ahmad_pro/secreens/Recommendations/recommendations.dart';
import 'package:ahmad_pro/secreens/contactUs/contactUs.dart';
import 'package:ahmad_pro/secreens/videosProChart/allVideosProChart.dart';
import 'package:ahmad_pro/services/UserData.dart';
import 'package:flutter/material.dart';
import 'package:ahmad_pro/secreens/prochartroom/prochartRoom.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  Timer _timer;
  int counter = 5;

  startTimer() {
    counter = 5;
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          loading = false;
        });
        _timer.cancel();
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  List<HomeTapsModels> lsitOfTapsData1 = [
    HomeTapsModels(
      image: 'lib/images/eventicons.png',
      titleAr: 'غرفة',
      titleEn: 'Pro Chart',
    ),
    HomeTapsModels(
      image: 'lib/images/eventicons.png',
      titleAr: 'توصيات',
      titleEn: 'Pro Chart VIP',
    ),
  ];
  List<HomeTapsModels> lsitOfTapsData2 = [
    HomeTapsModels(
      image: 'lib/images/eventicons.png',
      titleAr: 'قسم التعليم',
      titleEn: 'Pro Chart VIP',
    ),
    HomeTapsModels(
      image: 'lib/images/eventicons.png',
      titleAr: 'مكتبة الفيديو',
      titleEn: 'Video Pro Chart',
    ),
  ];
  List<String> namesList = [
    'Silver',
    'Mosawi',
    "Elite",
  ];
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (loading)
          ? Container(
              child: Center(
                  // child: CircularProgressIndicator.adaptive(),
                  ),
            )
          : SafeArea(
              child: ListView(
                shrinkWrap: true,
                primary: true,
                children: [
                  suerHomeAppBar(),
                  homeTabsFirst(list: lsitOfTapsData1),
                  contactWithAhmed(context),
                  homeTabsTow(list: lsitOfTapsData2),
                  homeTabsName(),
                ],
              ),
            ),
    );
  }

  contactWithAhmed(BuildContext context) {
    return FutureBuilder(
      future: ProChartVIPModelsApi.futchProChartVIP(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return (snapshot.data == null)
              ? Container()
              : (snapshot.data.contactUsBanner == '')
                  ? Container()
                  : InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ContactUs(),
                          ),
                        );
                      },
                      child: Container(
                        height: 100,
                        width: 355,
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                        child: customCachedNetworkImage(
                          context: context,
                          url: snapshot.data.contactUsBanner,
                        ),
                      ),
                    );
        } else {
          return Container();
        }
      },
    );
  }

  suerHomeAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      color: Color(0xfff04B085),
      child: StreamBuilder<Users>(
        stream:
            DatabaseServices(userid: User.userid, context: context).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Users userData = snapshot.data;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ',Welcome',
                  style: AppTheme.headingColorBlue.copyWith(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      userData.name,
                      style: AppTheme.headingColorBlue.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
        },
      ),
    );
  }

  homeTabsFirst({List<HomeTapsModels> list}) {
    return FutureBuilder(
      future: VisitorHomeIconsApi.futchVisitorHomeIcons(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return (snapshot.data == null)
              ? Container()
              : GridView.count(
                  crossAxisCount: 2,
                  primary: false,
                  childAspectRatio: .97,
                  shrinkWrap: true,
                  children: List.generate(
                    snapshot.data.userHomeIconsRow1.length,
                    (index) {
                      return (snapshot.data.userHomeIconsRow1[index] == '')
                          ? Container()
                          : InkWell(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ALLRomes(),
                                      ),
                                    );
                                    break;

                                  default:
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => Recommendations(),
                                      ),
                                    );
                                }
                              },
                              child: Card(
                                elevation: 3,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: (index == 0)
                                            ? Color(0xfffFF9B63)
                                            : Color(0xfff067FA5),
                                        width: 5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 110,
                                        width: 110,
                                        child: customCachedNetworkImage(
                                            context: context,
                                            url: snapshot
                                                .data.userHomeIconsRow1[index]),
                                      ),
                                      Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              list[index].titleAr,
                                              textAlign: TextAlign.right,
                                              style: AppTheme.heading,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              list[index].titleEn,
                                              textAlign: TextAlign.left,
                                              style: AppTheme.heading
                                                  .copyWith(color: customColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }

  homeTabsTow({List<HomeTapsModels> list}) {
    return FutureBuilder(
      future: VisitorHomeIconsApi.futchVisitorHomeIcons(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return (snapshot.data == null)
              ? Container()
              : GridView.count(
                  crossAxisCount: 2,
                  primary: false,
                  childAspectRatio: .97,
                  shrinkWrap: true,
                  children: List.generate(
                    snapshot.data.userHomeIconsRow2.length,
                    (index) {
                      return (snapshot.data.userHomeIconsRow2[index] == '')
                          ? Container()
                          : InkWell(
                              onTap: () {
                                switch (index) {
                                  case 1:
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => AllVideosProChart(),
                                      ),
                                    );
                                    break;

                                  default:
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => LearningSection(),
                                      ),
                                    );
                                }
                              },
                              child: Card(
                                elevation: 3,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: (index == 0)
                                            ? Color(0xfff6C089B)
                                            : Color(0xfffF00B27),
                                        width: 5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 110,
                                        width: 110,
                                        child: customCachedNetworkImage(
                                            context: context,
                                            url: snapshot
                                                .data.userHomeIconsRow2[index]),
                                      ),
                                      Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              list[index].titleAr,
                                              textAlign: TextAlign.right,
                                              style: AppTheme.heading,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              list[index].titleEn,
                                              textAlign: TextAlign.left,
                                              style: AppTheme.heading
                                                  .copyWith(color: customColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }

  homeTabsName() {
    return FutureBuilder(
      future: MyRoomsApi.fetchAllMyRooms(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return (snapshot.data == null || snapshot.data.isEmpty)
              ? Container()
              : GridView.count(
                  crossAxisCount: 3,
                  primary: false,
                  childAspectRatio: 1,
                  shrinkWrap: true,
                  children: List.generate(
                    snapshot.data.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProchartRoom(
                                rooms: snapshot.data[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xfff04B085),
                                  width: 5,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  snapshot.data[index].name,
                                  textAlign: TextAlign.center,
                                  style: AppTheme.heading.copyWith(
                                    color: customColor,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Room',
                                  textAlign: TextAlign.left,
                                  style: AppTheme.subHeading,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }
}
