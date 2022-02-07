import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/myPlanApi.dart';
import 'package:ahmad_pro/secreens/ProChartVIP/proChartVIP.dart';
import 'package:flutter/material.dart';

class MyPlans extends StatefulWidget {
  @override
  _MyPlansState createState() => _MyPlansState();
}

class _MyPlansState extends State<MyPlans> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('خططي'),
      ),
      body: FutureBuilder(
        future: MyPlansApi.fetchMyPlans(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return (snapshot.data == null || snapshot.data.isEmpty)
                ? Center(
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => ProChartVIP()),
                        );
                      },
                      color: customColor,
                      child: Text(
                        'اشترك الان',
                        style: AppTheme.heading.copyWith(color: Colors.white),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    primary: true,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                color: customColor,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    snapshot.data[index].planName,
                                    style: AppTheme.heading.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 30,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Text(
                                            'تاريخ البدا : ',
                                            style: AppTheme.heading.copyWith(
                                              color: customColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data[index].fromDate,
                                            style: AppTheme.subHeading,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Text(
                                            'تاريخ الانتهاء : ',
                                            style: AppTheme.heading.copyWith(
                                              color: customColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data[index].toDate,
                                            style: AppTheme.subHeading,
                                          ),
                                        ],
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
    );
  }
}
