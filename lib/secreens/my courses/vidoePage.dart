import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/couresApi.dart';
import 'package:ahmad_pro/secreens/my%20courses/components/videoscreens.dart';
import 'package:flutter/material.dart';

class MyCoursesVideoPage extends StatefulWidget {
  final String title;
  final String videoId;

  const MyCoursesVideoPage({Key key, this.title, this.videoId})
      : super(key: key);
  @override
  _MyCoursesVideoPageState createState() => _MyCoursesVideoPageState();
}

class _MyCoursesVideoPageState extends State<MyCoursesVideoPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (widget.videoId == '')
          ? Center(
              child: Container(
                child: Text(
                  'سيتوفر الفصل قريبا',
                  style: AppTheme.heading.copyWith(
                    color: customColor,
                  ),
                ),
              ),
            )
          : FutureBuilder(
              future: CoursesApi.getVideoMp4Link(id: widget.videoId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return (snapshot.data == null || snapshot.data.isEmpty)
                      ? Center(
                          child: Container(
                            child: Text(
                              'سيتوفر الفصل قريبا',
                              style: AppTheme.heading.copyWith(
                                color: customColor,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: ChewieVideo(
                            videoUrl: snapshot.data,
                          ),
                        );
                } else {
                  return Center(child: CircularProgressIndicator.adaptive());
                }
              },
            ),
    );
  }
}
