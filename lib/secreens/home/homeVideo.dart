import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/couresApi.dart';
import 'package:ahmad_pro/models/homeVideoApi.dart';
import 'package:ahmad_pro/secreens/my%20courses/components/videoscreens.dart';
import 'package:flutter/material.dart';

class HomeVideo extends StatefulWidget {
  @override
  _HomeVideoState createState() => _HomeVideoState();
}

class _HomeVideoState extends State<HomeVideo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HomeVideoApi.futchHomeVideo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return (snapshot.data == null)
              ? Container()
              : (snapshot.data.homeVideoTitle == '' ||
                      snapshot.data.homeVideoTitle == '')
                  ? Container()
                  : Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (snapshot.data.homeVideo == '')
                              ? Container()
                              : FutureBuilder(
                                  future: CoursesApi.getVideoMp4Link(
                                      id: snapshot.data.homeVideo),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      print(snapshot.data);
                                      return (snapshot.data == null ||
                                              snapshot.data.isEmpty)
                                          ? Container()
                                          : Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: ChewieVideo(
                                                  videoUrl: snapshot.data,
                                                ),
                                              ),
                                            );
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator.adaptive());
                                    }
                                  },
                                ),
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (snapshot.data.videoFeaturesBg != null ||
                                        snapshot.data.videoFeaturesBg != '')
                                    ? NetworkImage(
                                        snapshot.data.videoFeaturesBg)
                                    : AssetImage(
                                        'lib/images/homeback.jpg',
                                      ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              children: [
                                Text(
                                  snapshot.data.homeVideoTitle,
                                  style: AppTheme.subHeading.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                (snapshot.data.homeVideoTxt1 == '')
                                    ? Container()
                                    : rowTexts(
                                        context: context,
                                        title: snapshot.data.homeVideoTxt1,
                                      ),
                                (snapshot.data.homeVideoTxt2 == '')
                                    ? Container()
                                    : rowTexts(
                                        context: context,
                                        title: snapshot.data.homeVideoTxt2,
                                      ),
                                (snapshot.data.homeVideoTxt3 == '')
                                    ? Container()
                                    : rowTexts(
                                        context: context,
                                        title: snapshot.data.homeVideoTxt3,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
        } else {
          return Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }

  rowTexts({BuildContext context, String title}) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: Colors.white,
        ),
        SizedBox(width: 5),
        SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          child: Text(
            title,
            style: AppTheme.subHeading.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
