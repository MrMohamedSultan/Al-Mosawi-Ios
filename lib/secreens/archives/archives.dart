import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/RecomendationsApi.dart';

import 'package:ahmad_pro/secreens/archives/archiveRecoPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Archives extends StatefulWidget {
  @override
  _ArchivesState createState() => _ArchivesState();
}

class _ArchivesState extends State<Archives> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أرشيف التوصيات'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          customOnRefresh(onRefresh: () {
            setState(() {
              loading = !loading;
            });
          }, affterRefresh: () {
            setState(() {
              loading = !loading;
            });
          });
        },
        child: (loading)
            ? Container(
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            : FutureBuilder(
                future: RecomendationsApi.fetchAllArchiveRecomendations(
                    type: "archive"),
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
                              ],
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            primary: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'الاسم',
                                      style: AppTheme.heading.copyWith(
                                        color: customColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'المعدل',
                                      style: AppTheme.heading.copyWith(
                                        color: customColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ArchiveRecomPage(
                                            title: snapshot
                                                .data[index].currencyName,
                                            recommend: snapshot
                                                .data[index].recomendations,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 3,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data[index].currencyName,
                                              style:
                                                  AppTheme.heading.copyWith(),
                                            ),
                                            (snapshot.data[index].arrow == 'up')
                                                ? SvgPicture.asset(
                                                    'lib/icons/stockUp.svg',
                                                    color: customColor,
                                                    height: 15,
                                                  )
                                                : Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'lib/images/chartlineDown.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                            Row(
                                              children: [
                                                Text(
                                                  snapshot.data[index].number,
                                                  style:
                                                      AppTheme.heading.copyWith(
                                                    color: (snapshot.data[index]
                                                                .arrow !=
                                                            'up')
                                                        ? Colors.red
                                                        : customColor,
                                                  ),
                                                ),
                                                Transform.rotate(
                                                  angle: 180 * 3.14 / 180,
                                                  child: Icon(
                                                    Icons.arrow_back_ios,
                                                    size: 15,
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
                            ],
                          );
                  } else {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }
                },
              ),
      ),
    );
  }
}
