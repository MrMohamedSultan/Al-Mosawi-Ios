import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/theBolg.dart';
import 'package:ahmad_pro/secreens/theBlog/bolgDetailes.dart';
import 'package:flutter/material.dart';

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المدونة',
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        primary: true,
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          FutureBuilder(
            future: TheBolgApi.fetchAllTheBolg(type: 'free'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return (snapshot.data == null || snapshot.data.isEmpty)
                    ? Container(
                        child: Center(
                          child: Text(
                            'اسحب الشاشه لاسفل لاعاده التحميل',
                            style: AppTheme.heading,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BolgDetailes(
                                    theBolg: snapshot.data[index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (snapshot.data[index].image == null ||
                                          snapshot.data[index].image == '')
                                      ? Container()
                                      : Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: customCachedNetworkImage(
                                              boxFit: BoxFit.cover,
                                              context: context,
                                              url: snapshot.data[index].image,
                                            ),
                                          ),
                                        ),
                                  Container(
                                    width: (snapshot.data[index].image ==
                                                null ||
                                            snapshot.data[index].image == '')
                                        ? MediaQuery.of(context).size.width - 40
                                        : MediaQuery.of(context).size.width -
                                            180,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data[index].date,
                                          style: AppTheme.subHeading.copyWith(
                                            color: customColorGray,
                                            fontSize: 9,
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 40,
                                          child: Text(
                                            snapshot.data[index].name,
                                            style: AppTheme.heading.copyWith(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 55,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            parseHtmlString(
                                                snapshot.data[index].contant ??
                                                    snapshot.data[index]
                                                        .description ??
                                                    ''),
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
                      );
              } else {
                return Center(child: CircularProgressIndicator.adaptive());
              }
            },
          ),
        ],
      ),
    );
  }
}
