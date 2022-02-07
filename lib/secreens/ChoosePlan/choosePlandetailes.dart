import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/plansApi.dart';
import 'package:ahmad_pro/models/prodact.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/services/dbhelper.dart';
import 'package:ahmad_pro/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChoosePlanDetailes extends StatefulWidget {
  final Plans plan;

  const ChoosePlanDetailes({Key key, @required this.plan}) : super(key: key);
  @override
  _ChoosePlanDetailesState createState() => _ChoosePlanDetailesState();
}

class _ChoosePlanDetailesState extends State<ChoosePlanDetailes> {
  DbHehper helper;
  getBuyPlan() async {
    User.userSkipLogIn = await MySharedPreferences.getUserSkipLogIn();
    User.userCantBuy = await MySharedPreferences.getUserCantBuy();
  }

  @override
  void initState() {
    getBuyPlan();
    super.initState();
    helper = DbHehper();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.plan.features);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan.name),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'شهور' + '${widget.plan.plan_time}' + "كل",
                style: AppTheme.heading.copyWith(fontSize: 20),
              ),
              SizedBox(height: 20),
              (widget.plan.newPrice == null)
                  ? Container()
                  : Text(
                      '${widget.plan.newPrice} \$',
                      style: AppTheme.heading.copyWith(fontSize: 20),
                    ),
              (widget.plan.oldPrice == null)
                  ? Container()
                  : Text(
                      '${widget.plan.oldPrice} \$',
                      style: AppTheme.heading.copyWith(
                        fontSize: 20,
                        decoration: (widget.plan.newPrice == null)
                            ? TextDecoration.none
                            : TextDecoration.lineThrough,
                      ),
                    ),
            ],
          ),
          SizedBox(height: 30),
          (widget.plan.features.isEmpty || widget.plan.features.isEmpty == null)
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: widget.plan.features.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        contant(title: widget.plan.features[index]),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
          // ignore: deprecated_member_use
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: customColor,
            onPressed: () async {
              if (User.userCantBuy == true) {
                sikpDialog(context: context);
              } else {
                if (User.userCantBuy == true) {
                  cardDialog(
                      context: context,
                      message:
                          'انت بالفعل مشارك في خطه عليك استكمال عمليه الاشاراك اول او حذف الخطه من السله حتي تسطيع الاشتراك في خطة اخري');
                } else {
                  {
                    setState(() {
                      MySharedPreferences.saveUserPayPlan(true);

                      increaseCartTotlaPrice(
                        price: (widget.plan.newPrice == null)
                            ? double.parse(widget.plan.oldPrice.toString())
                            : double.parse(widget.plan.newPrice.toString()),
                      );
                    });
                    ConsultantProdect prodect = ConsultantProdect({
                      'consultantId': widget.plan.id,
                      'type': 'plan',
                      'date': '',
                      'dateId': 0,
                      'time': '',
                      'title': widget.plan.name,
                      'price': (widget.plan.newPrice == null)
                          ? double.parse(widget.plan.oldPrice.toString())
                          : double.parse(widget.plan.newPrice.toString()),
                      'proImageUrl': '',
                    });
                    // ignore: unused_local_variable
                    int id = await helper.createProduct(prodect);
                    cardDialog(context: context);
                  }
                }
              }
            },
            child: Text(
              'اشترك الان',
              style: AppTheme.heading.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  contant({String title}) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: Center(
            child: Icon(
              FontAwesomeIcons.check,
              color: Colors.white,
              size: 10,
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: AppTheme.heading.copyWith(
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
