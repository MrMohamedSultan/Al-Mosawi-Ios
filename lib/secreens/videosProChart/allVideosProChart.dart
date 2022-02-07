import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/videoProChartApi.dart';
import 'package:ahmad_pro/secreens/videosProChart/videosProChartDetaills.dart';
import 'package:flutter/material.dart';

class AllVideosProChart extends StatefulWidget {
  @override
  _AllVideosProChartState createState() => _AllVideosProChartState();
}

class _AllVideosProChartState extends State<AllVideosProChart> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مكتبة الفيديو'),
      ),
      body: FutureBuilder(
        future: VideoProchartApi.fetchAllVideoProChart(),
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
                : ListView(
                    shrinkWrap: true,
                    primary: true,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => VideosProChartDetaills(
                                    videoProChart: snapshot.data[index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    child: customCachedNetworkImage(
                                      context: context,
                                      url: snapshot.data[index].image,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 180,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            snapshot.data[index].title,
                                            style: AppTheme.heading.copyWith(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            parseHtmlString(snapshot
                                                .data[index].description),
                                            style: AppTheme.subHeading.copyWith(
                                              color: customColorGray,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
          } else {
            return Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
