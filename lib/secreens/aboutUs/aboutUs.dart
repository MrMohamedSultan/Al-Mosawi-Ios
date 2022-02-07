import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/abutUsApi.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('من نحن'),
      ),
      body: FutureBuilder(
        future: AboutUsApi.futchAboutUs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return (snapshot.data == null)
                ? Container()
                : ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: customCachedNetworkImage(
                          context: context,
                          url: snapshot.data.image,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          snapshot.data.title,
                          style: AppTheme.heading,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Text(
                          parseHtmlString(snapshot.data.des),
                          style: AppTheme.heading,
                        ),
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
