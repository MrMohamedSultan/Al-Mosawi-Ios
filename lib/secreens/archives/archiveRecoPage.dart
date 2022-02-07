import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/RecomendationsApi.dart';
import 'package:ahmad_pro/secreens/Recommendations/recommendationsDetailes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ArchiveRecomPage extends StatefulWidget {
  final String title;
  final List<RecomendationsModels> recommend;

  const ArchiveRecomPage({Key key, this.title, this.recommend})
      : super(key: key);
  @override
  _ArchiveRecomPageState createState() => _ArchiveRecomPageState();
}

class _ArchiveRecomPageState extends State<ArchiveRecomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        primary: true,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: widget.recommend.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecommendationsDetailes(
                    recommend: widget.recommend[index],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  (widget.recommend[index].name ?? ''),
                                  style: AppTheme.subHeading.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 10),
                                (widget.recommend[index].buyOrSale == '' ||
                                        widget.recommend[index].buyOrSale ==
                                            null)
                                    ? Container()
                                    : Text(
                                        (widget.recommend[index].buyOrSale) ??
                                            '',
                                        style: AppTheme.heading.copyWith(
                                          color: (widget.recommend[index]
                                                      .buyOrSale ==
                                                  'شراء')
                                              ? customColor
                                              : Colors.red,
                                        ),
                                      ),
                              ],
                            ),
                            Row(
                              children: [
                                (widget.recommend[index].statusLoss == 'gain' ||
                                        widget.recommend[index].statusLoss ==
                                            'مكسب')
                                    ? Row(
                                        children: [
                                          SvgPicture.asset(
                                            'lib/icons/stockUp.svg',
                                            color: customColor,
                                            height: 15,
                                          ),
                                          Text(
                                            ' ( ربح )',
                                            style: AppTheme.heading.copyWith(
                                              color: customColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Container(
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
                                          Text(
                                            ' ( خساره )',
                                            style: AppTheme.heading.copyWith(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          color: customColorDivider,
                          thickness: 2,
                        ),
                      ],
                    ),

                    ///title
                    ///سعر الهرجروح
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (widget.recommend[index].entryPrice == '' ||
                                widget.recommend[index].entryPrice == null)
                            ? Container()
                            : Container(
                                width: 85,
                                child: Text(
                                  'سعر الدخول',
                                  style: AppTheme.subHeading.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                        (widget.recommend[index].entryPrice == '' ||
                                widget.recommend[index].entryPrice == null)
                            ? Container()
                            : Container(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '(${(widget.recommend[index].entryPrice) ?? ''})',
                                    style: AppTheme.subHeading.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                        Container(
                          child: Text(
                            (widget.recommend[index].status) ?? "",
                            style: AppTheme.subHeading.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    ///سعر الخروج
////الهدف
                    (widget.recommend[index].buyAreaGoals == '' ||
                            widget.recommend[index].buyAreaGoals == null)
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 85,
                                child: Text(
                                  'الهدف',
                                  style: AppTheme.subHeading.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      '(${(widget.recommend[index].buyAreaGoals) ?? ''})',
                                      style: AppTheme.subHeading.copyWith(
                                        fontWeight: FontWeight.w700,
                                      )),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),

                    ///الهدف
                    ///وقف الخساره
                    (widget.recommend[index].stopBuy == '' &&
                            widget.recommend[index].stopSelling == '')
                        ? Container()
                        : (widget.recommend[index].stopBuy != '')
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 85,
                                    child: Text(
                                      'وقف الخسارة',
                                      style: AppTheme.subHeading.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '(${(widget.recommend[index].stopBuy) ?? ''})',
                                        style: AppTheme.subHeading.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 85,
                                    child: Text(
                                      'وقف الخسارة',
                                      style: AppTheme.subHeading.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '(${(widget.recommend[index].stopSelling) ?? ''})',
                                        style: AppTheme.subHeading
                                          ..copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (widget.recommend[index].theTime == '' ||
                                widget.recommend[index].theTime == null)
                            ? Container()
                            : Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  color: customColor,
                                ),
                                child: Center(
                                  child: Text(
                                    (widget.recommend[index].theTime) ?? '',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.heading.copyWith(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ),
                        (widget.recommend[index].points == '' ||
                                widget.recommend[index].points == null)
                            ? Container()
                            : Text(
                                (widget.recommend[index].points) ?? '',
                                textAlign: TextAlign.center,
                                style: AppTheme.heading.copyWith(
                                  color: customColor,
                                  fontSize: 12,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 10),
                    (widget.recommend[index].comment == '' ||
                            widget.recommend[index].comment == null)
                        ? Container()
                        : Text(
                            '(${widget.recommend[index].comment})',
                            style: AppTheme.subHeading,
                          ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (widget.recommend[index].dayDate) ?? '',
                        style: AppTheme.subHeading.copyWith(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
