import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/proChartVipApi.dart';
import 'package:ahmad_pro/secreens/ChoosePlan/choosePlan.dart';
import 'package:ahmad_pro/secreens/in_app_purchases/purchases_integrtions.dart';
import 'package:flutter/material.dart';

class ProChartVIP extends StatefulWidget {
  @override
  _ProChartVIPState createState() => _ProChartVIPState();
}

class _ProChartVIPState extends State<ProChartVIP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'pro chart VIP',
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        primary: true,
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: [
          FutureBuilder(
            future: ProChartVIPModelsApi.futchProChartVIP(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return (snapshot.data == null)
                    ? Container()
                    : ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: [
                          Text(
                            snapshot.data.title,
                            style: AppTheme.heading,
                          ),
                          SizedBox(height: 10),
                          Text(
                            parseHtmlString(
                              snapshot.data.des,
                            ),
                            style: AppTheme.subHeading,
                          ),
                          SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: snapshot.data.features.length,
                            itemBuilder: (context, index) {
                              return tradingAccountRow(
                                contant: snapshot.data.features[index]['text'],
                                name: snapshot.data.features[index]['title'],
                                icon: snapshot.data.features[index]['image'],
                                index: index + 1,
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
          CustomButton(
            onPress: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChoosePlan(),
                      //Integrations(),
                ),
              );
            },
            text: 'اشترك',
          ),
        ],
      ),
    );
  }

  tradingAccountRow({String name, String contant, String icon, int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              index.toString(),
              style: AppTheme.heading,
            ),
            SizedBox(width: 10),
            Container(
              width: 1,
              height: 30,
              color: customColorGray.withOpacity(.5),
            ),
            SizedBox(width: 10),
            Container(
              width: 30,
              height: 30,
              child: customCachedNetworkImage(
                context: context,
                url: icon,
              ),
            ),
            SizedBox(width: 10),
            Text(
              name,
              style: AppTheme.heading,
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          contant,
          style: AppTheme.subHeading.copyWith(
            color: customColorGray,
            fontSize: 10,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Divider(
            color: customColor.withOpacity(.5),
            thickness: 2,
          ),
        ),
      ],
    );
  }
}
