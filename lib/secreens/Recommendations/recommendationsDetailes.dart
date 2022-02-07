import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/RecomendationsApi.dart';
import 'package:flutter/material.dart';

class RecommendationsDetailes extends StatefulWidget {
  final RecomendationsModels recommend;

  const RecommendationsDetailes({Key key, @required this.recommend})
      : super(key: key);
  @override
  _RecommendationsDetailesState createState() =>
      _RecommendationsDetailesState();
}

class _RecommendationsDetailesState extends State<RecommendationsDetailes> {
  bool tappd = false;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    print("widget.recommend.forms:${widget.recommend.forms}");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recommend.name),
      ),
      body: ListView(
        shrinkWrap: true,
        primary: true,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Container(
            height: 150,
            child: customCachedNetworkImage(
              context: context,
              url: widget.recommend.image,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: (widget.recommend.name == null ||
                        widget.recommend.name == '')
                    ? Container()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'العملة /الزوج',
                            style: AppTheme.heading.copyWith(
                              color: customColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.recommend.name,
                            style: AppTheme.heading,
                          ),
                        ],
                      ),
              ),
              SizedBox(width: 10),
              (count == 2)
                  ? Container(
                      child: Text(
                        ' تم دخول الصفقة من قبل',
                        style: AppTheme.headingColorBlue.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    )
                  : Expanded(
                      child: CustomButtonWithchild(
                        child: Text(
                          (tappd) ? 'خروج' : 'دخول',
                          style: AppTheme.heading.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        color: (tappd) ? Colors.red : customColor,
                        onPress: () {
                          setState(() {
                            tappd = !tappd;
                            count = count + 1;
                          });
                        },
                      ),
                    ),
            ],
          ),
          SizedBox(height: 20),
          (widget.recommend.direction == null ||
                  widget.recommend.direction == '')
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الأتجاة',
                      style: AppTheme.heading.copyWith(
                        color: customColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      parseHtmlString(widget.recommend.direction),
                      style: AppTheme.heading,
                    ),
                  ],
                ),
          SizedBox(height: 20),
          (widget.recommend.forms == null || widget.recommend.forms == '')
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'النموذج',
                      style: AppTheme.heading.copyWith(
                        color: customColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      parseHtmlString(widget.recommend.forms),
                      style: AppTheme.heading,
                    ),
                  ],
                ),
          (widget.recommend.buy == null || widget.recommend.buy == '')
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مناطق الشرائية',
                      style: AppTheme.heading.copyWith(
                        color: customColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.recommend.buy.toString(),
                      style: AppTheme.heading,
                    ),
                  ],
                ),
          SizedBox(height: 20),
          (widget.recommend.selling == null || widget.recommend.selling == '')
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مناطق البيعية',
                      style: AppTheme.heading.copyWith(
                        color: customColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.recommend.selling.toString(),
                      style: AppTheme.heading,
                    ),
                  ],
                ),
          SizedBox(height: 20),
          (widget.recommend.buyAreaGoals == null ||
                  widget.recommend.buyAreaGoals == '')
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الأهداف لمناطق الشرائية',
                      style: AppTheme.heading.copyWith(
                        color: customColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.recommend.buyAreaGoals.toString(),
                      style: AppTheme.heading,
                    ),
                  ],
                ),
          SizedBox(height: 20),
          (widget.recommend.stopBuy == null || widget.recommend.forms == '')
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إيقاف الخسارة لمناطق الشراء',
                      style: AppTheme.heading.copyWith(
                        color: customColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.recommend.stopBuy.toString(),
                      style: AppTheme.heading,
                    ),
                  ],
                ),
          SizedBox(height: 20),
          (widget.recommend.forms == '' || widget.recommend.forms == null)
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إيقاف الخسارة لمناطق البيع',
                      style: AppTheme.heading.copyWith(
                        color: customColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      parseHtmlString(widget.recommend.forms),
                      style: AppTheme.heading,
                    ),
                  ],
                ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
