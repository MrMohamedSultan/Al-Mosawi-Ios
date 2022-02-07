import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/RecomendationsApi.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/secreens/ProChartVIP/proChartVIP.dart';
import 'package:ahmad_pro/secreens/Recommendations/recomeendCard.dart';
import 'package:ahmad_pro/secreens/Recommendations/recommendationsDetailes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FreeRecommendations extends StatefulWidget {
  @override
  _FreeRecommendationsState createState() => _FreeRecommendationsState();
}

class _FreeRecommendationsState extends State<FreeRecommendations> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'التوصيات المجانيه',
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          primary: true,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: [
            // (User.userSkipLogIn == false) ? Container() : slider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                'التوصيات',
                style: AppTheme.heading.copyWith(
                  color: customColor,
                  fontSize: 20,
                ),
              ),
            ),
            FutureBuilder(
              future: RecomendationsApi.fetchAllRecomendations(type: "free"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return (snapshot.data == null || snapshot.data.isEmpty)
                      ? Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'لا توجد توصيات مجانية في الوقت الحالى',
                                  style: AppTheme.heading,
                                  textAlign: TextAlign.center,
                                ),
                                // Text(
                                //   'اسحب الشاشه لاسفل لاعاده التحميل',
                                //   style: AppTheme.heading,
                                //   textAlign: TextAlign.center,
                                // ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => RecommendationsDetailes(
                                      recommend: snapshot.data[index],
                                    ),
                                  ),
                                );
                              },
                              child: recomeendCard(snapshot, index, 'free'),
                            );
                          },
                        );
                } else {
                  return Center(child: CircularProgressIndicator.adaptive());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  slider() {
    return Container(
      color: customColor,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Text(
            'لعدم فقد أي جديد اشترك وستصلك الإشعارات بالتوصيات',
            style: AppTheme.subHeading.copyWith(
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProChartVIP(),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              child: Text(
                'اشترك الان',
                style: AppTheme.subHeading.copyWith(
                  color: customColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
