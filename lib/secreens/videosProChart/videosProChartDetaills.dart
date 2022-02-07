import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/couresApi.dart';
import 'package:ahmad_pro/models/videoProChartApi.dart';
import 'package:ahmad_pro/secreens/my%20courses/components/videoscreens.dart';
import 'package:flutter/material.dart';

class VideosProChartDetaills extends StatefulWidget {
  final VideoProChart videoProChart;

  const VideosProChartDetaills({Key key, this.videoProChart}) : super(key: key);
  @override
  _VideosProChartDetaillsState createState() => _VideosProChartDetaillsState();
}

class _VideosProChartDetaillsState extends State<VideosProChartDetaills> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        primary: true,
        children: [
          (widget.videoProChart.videoCode == '')
              ? Container(
                  child: customCachedNetworkImage(
                    context: context,
                    url: widget.videoProChart.image,
                  ),
                )
              : FutureBuilder(
                  future: CoursesApi.getVideoMp4Link(
                      id: widget.videoProChart.videoCode),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      return (snapshot.data == null || snapshot.data.isEmpty)
                          ? Container()
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              widget.videoProChart.title,
              style: AppTheme.heading.copyWith(color: customColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              parseHtmlString(widget.videoProChart.description),
              textAlign: TextAlign.justify,
              style: AppTheme.subHeading,
            ),
          ),
        ],
      ),
    );
  }
}
