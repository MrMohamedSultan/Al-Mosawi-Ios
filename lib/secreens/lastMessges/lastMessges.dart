import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/MyMessagesApi.dart';
import 'package:ahmad_pro/secreens/chatRome/chatRome.dart';
import 'package:ahmad_pro/secreens/contactUs/contactUs.dart';
import 'package:ahmad_pro/services/network_sensitive.dart';
import 'package:flutter/material.dart';

class LastMessges extends StatefulWidget {
  @override
  _LastMessgesState createState() => _LastMessgesState();
}

class _LastMessgesState extends State<LastMessges> {
  bool loading = false;
  Future<Null> onRefresh() async {
    setState(() {
      loading = !loading;
    });

    await Future.delayed(
      Duration(seconds: 2),
      () {
        setState(() {
          loading = !loading;
        });
      },
    );
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المرسلات السابقة'),
      ),
      body: NetworkSensitive(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: (loading)
              ? Container()
              : FutureBuilder(
                  future: MyMessageApi.fetchAllMyMassege(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return (snapshot.data.isEmpty)
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'لا توجد مراسلات سابقه',
                                    style: AppTheme.heading,
                                  ),
                                  SizedBox(height: 10),
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ContactUs()),
                                      );
                                    },
                                    color: customColor,
                                    child: Text(
                                      'تواصل مع احمد الموسوي',
                                      style: AppTheme.heading
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              primary: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ChatRome(
                                              title: 'Ahmed AlMOSAWI',
                                              message: snapshot.data[index],
                                              messageID:
                                                  snapshot.data[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Card(
                                          elevation: 3,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  parseHtmlString(snapshot
                                                      .data[index].content),
                                                  style: AppTheme.subHeading,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data[index].name,
                                                      style: AppTheme.subHeading
                                                          .copyWith(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data[index].date,
                                                      style: AppTheme.subHeading
                                                          .copyWith(
                                                        fontSize: 10,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Divider(
                                        color: customColorDivider,
                                        thickness: 2,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                    } else {
                      return Center(child: CircularProgressIndicator.adaptive());
                    }
                  },
                ),
        ),
      ),
    );
  }
}
