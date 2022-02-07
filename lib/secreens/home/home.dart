import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/contactUsApi.dart';
import 'package:ahmad_pro/models/couresApi.dart';
import 'package:ahmad_pro/models/freeCoursesApi.dart';
import 'package:ahmad_pro/models/homeVideoApi.dart';
import 'package:ahmad_pro/models/proChartVipApi.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/secreens/ProChartVIP/proChartVIP.dart';
import 'package:ahmad_pro/secreens/TradingAccount/tradingAccount.dart';
import 'package:ahmad_pro/secreens/authenticate/logIn/login.dart';
import 'package:ahmad_pro/secreens/cart/cart.dart';
import 'package:ahmad_pro/secreens/contactUs/contactUs.dart';
import 'package:ahmad_pro/secreens/courses/coursesDetailes.dart';
import 'package:ahmad_pro/secreens/home/homeVideo.dart';
import 'package:ahmad_pro/secreens/in_app_purchases/consumable_store.dart';
import 'package:ahmad_pro/secreens/in_app_purchases/data.dart';
import 'package:ahmad_pro/secreens/in_app_purchases/purchases_integrtions.dart';
import 'package:ahmad_pro/secreens/userHome/UserHome.dart';
import 'package:ahmad_pro/services/homeProvider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../sharedPreferences.dart';

class HomePages extends StatefulWidget {
  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {



  getTotalPrice() async {
    Cart.totalPraices = await MySharedPreferences.getTotalPrice();
    User.userLogIn = await MySharedPreferences.getUserSingIn();
    User.userSkipLogIn = await MySharedPreferences.getUserSkipLogIn();
    User.userBuyPlan = await MySharedPreferences.getUserBuyPlan();
    User.userCantBuy = await MySharedPreferences.getUserCantBuy();
    User.userPassword = await MySharedPreferences.getUserUserPassword();
    User.userToken = await MySharedPreferences.getUserToken();
  }

  @override
  void initState() {
    getTotalPrice();
    super.initState();
    print("UserSkiping LOgIN:${User.userSkipLogIn}");
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<CheckUserSubscriptionsProvider>(context).isUserPayPaln);
    if (Provider.of<CheckUserSubscriptionsProvider>(context).isUserPayPaln) {
      return UserHome();
    } else {
      return Home();
    }
  }
}

class Home extends StatefulWidget {
  static final route = '/home';

  @override
  _HomeState createState() => _HomeState();
}

/// *********************************************************************************
const bool _kAutoConsume = true;

const String _kConsumableId = 'bronze';

const String _kNonRenewingFreeCourseId = 'freecourse';
const String _kNonRenewingGoldenId = 'golden';
const String _kNonRenewingManageCapitalId = 'manag_capitale';
const String _kNonRenewingPrinciplesId = 'principles';
const String _kNonRenewingProAnalysisId = 'pro_analisys';
const String _kNonRenewingSilverId = 'silver';
const String _kNonRenewingYourStrategyId = 'your_strategy';

const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kNonRenewingFreeCourseId,
  _kNonRenewingGoldenId,
  _kNonRenewingManageCapitalId,
  _kNonRenewingPrinciplesId,
  _kNonRenewingProAnalysisId,
  _kNonRenewingSilverId,
  _kNonRenewingYourStrategyId
];

class _HomeState extends State<Home> {
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<dynamic> _subscription;


  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError ;
  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
    await _connection.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError =null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
    await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }
    List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });


    /********************  Call Loading Methods from consumables store *****************/

    List<String> conFreeCourses = await ConsumableStore.loadFreeCourse();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = conFreeCourses;
      _purchasePending = false;
      _loading = false;
    });


    List<String> conYourStrategy = await ConsumableStore.loadYourStrategy();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = conYourStrategy;
      _purchasePending = false;
      _loading = false;
    });


    List<String> conSilver = await ConsumableStore.loadSilver();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = conSilver;
      _purchasePending = false;
      _loading = false;
    });


    List<String> conProAnalysis = await ConsumableStore.loadProAnalysis();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = conProAnalysis;
      _purchasePending = false;
      _loading = false;
    });


    List<String> conManageCapital = await ConsumableStore.loadManageCapital();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = conManageCapital;
      _purchasePending = false;
      _loading = false;
    });


    List<String> conGolden = await ConsumableStore.loadGolden();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = conGolden;
      _purchasePending = false;
      _loading = false;
    });

    List<String> conPrinciples = await ConsumableStore.loadPrinciples();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = conPrinciples;
      _purchasePending = false;
      _loading = false;
    });

    /******************************************************************************** */
  }
  /// ******************************************************************************************* */


  Timer _timer;
  int counter = 5;

  startTimer() {
    counter = 5;
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          loading = false;
        });
        _timer.cancel();
      },
    );
  }

  @override
  void initState() {
    /// Prepareing in app purchase
    initStoreInfo();
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
      print('🙄error ${error.toString()}');
    });
    ///***************************************************************************************** */
    startTimer();

    super.initState();
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  bool loading = true;
  List<String> numberTitleList = ['عميل', 'دورة مباشرة', 'دورة مسجلة'];

  //final navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: (loading)
          ? Container(
              child: Center(
                  // child: CircularProgressIndicator.adaptive(),
                  ),
            )
          : SingleChildScrollView(

      child: Column(    children: [
        HomeVideo(),
        freeCorsesSections(),
        SizedBox(height: 10),
        homeProChartSection(),
        successPartners(),
        SizedBox(height: 10),
        acountFeatures(),
        SizedBox(height: 10),
        homeBaner(),
        SizedBox(height: 10),
        contactWithAhmed(context),
        SizedBox(height: 10),
        sectionTitle(title: 'الدورات التدريبية'),
        SizedBox(height: 10),
        corsesSections(),
        SizedBox(height: 10),
      ],
       ),
            ),
    );




  }

  homeProChartSection() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: FutureBuilder(
            future: HomeVideoApi.futchHomeVideo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return (snapshot.data == null)
                    ? Container()
                    : Card(
                        elevation: 3,
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: customColor,
                                width: 5,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                child: customCachedNetworkImage(
                                    context: context,
                                    url:
                                        snapshot.data.homeProChartSectionImage),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (snapshot.data.homeProChartSectionTitle) ??
                                        "",
                                    textAlign: TextAlign.center,
                                    style: AppTheme.heading,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 50,
                                    child: Text(
                                      (snapshot.data.homeProChartSectionTxt) ??
                                          '',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.heading.copyWith(
                                        color: customColorGray,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
                                      color: customColor,
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 10,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'اشترك الان',
                                          style: AppTheme.heading.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => //Integrations()
                                              ProChartVIP(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
              } else {
                return Container();
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: FutureBuilder(
            future: HomeVideoApi.futchHomeVideo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return (snapshot.data == null)
                    ? Container()
                    : Card(
                        elevation: 3,
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xfff067FA5),
                                width: 5,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                child: customCachedNetworkImage(
                                    context: context,
                                    url:
                                        snapshot.data.homeYourDealSectionImage),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (snapshot.data.homeYourDealSectionTitle) ??
                                        '',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.heading,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 50,
                                    child: Text(
                                      (snapshot.data.homeYourDealSectionTxt) ??
                                          '',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.heading.copyWith(
                                        color: customColorGray,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
                                      color: Color(0xfff067FA5),
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 10,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'تتبع صفقتك الآن',
                                          style: AppTheme.heading.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      // launchInBrowser(
                                      //     'https://ahmadalmosawi.com/V2/calculator.html');
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }

  contactWithAhmed(BuildContext context) {
    return FutureBuilder(
      future: ProChartVIPModelsApi.futchProChartVIP(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return (snapshot.data == null)
              ? Container()
              : (snapshot.data.contactUsBanner == '')
                  ? Container()
                  : InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ContactUs(),
                          ),
                        );
                      },
                      child: Container(
                        height: 100,
                        width: 355,
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                        child: customCachedNetworkImage(
                          context: context,
                          url: snapshot.data.contactUsBanner,
                        ),
                      ),
                    );
        } else {
          return Container();
        }
      },
    );
  }

  parteners() {
    return FutureBuilder(
      future: ContactUsApi.futchContactUs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return (snapshot.data == null)
              ? Container()
              : ListView(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      primary: false,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      children: List.generate(
                        snapshot.data.parteners.length,
                        (index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: customCachedNetworkImage(
                              context: context,
                              url: snapshot.data.parteners[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
        } else {
          return Container();
        }
      },
    );
  }

  acountFeatures() {
    return FutureBuilder(
      future: ContactUsApi.futchContactUs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return (snapshot.data == null)
              ? Container()
              : ListView(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  children: [
                    Center(
                      child: Text(
                        'مميزات فتح حساب تداول  ',
                        style: AppTheme.headingColorBlue,
                      ),
                    ),
                    SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      primary: false,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      children: List.generate(
                        snapshot.data.acountFeatures.length,
                        (index) {
                          return Column(
                            children: [
                              Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width,
                                child: customCachedNetworkImage(
                                  context: context,
                                  url: snapshot.data.acountFeatures[index]
                                      ['image'],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                snapshot.data.acountFeatures[index]['title'],
                                style: AppTheme.heading,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomButtonWithchild(
                      child: Center(
                        child: Text(
                          'فتح حساب تداول ',
                          style: AppTheme.heading.copyWith(color: Colors.white),
                        ),
                      ),
                      color: customColor,
                      onPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TradingAccount(),
                          ),
                        );
                      },
                    ),
                  ],
                );
        } else {
          return Container();
        }
      },
    );
  }

  successPartners() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Text(
            'شركاء النجاح',
            style: AppTheme.heading,
          ),
          SizedBox(height: 10),
          parteners(),
          SizedBox(height: 10),
          FutureBuilder(
            future: HomeVideoApi.futchHomeVideo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return (snapshot.data == null)
                    ? Container()
                    : Container(
                        height: 90,
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.homeNumbers.length,
                          itemBuilder: (context, index) {
                            return cartPartners(
                              title: numberTitleList[index],
                              nummber: snapshot.data.homeNumbers[index],
                            );
                          },
                        ),
                      );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  cartPartners({String title, String nummber}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 110,
        width: 90,
        decoration: BoxDecoration(
            color: customColor, borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                nummber,
                style: AppTheme.subHeading.copyWith(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                title,
                style: AppTheme.subHeading.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  corsesSections() {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      height: 240,
      child: FutureBuilder(
        future: CoursesApi.fetchAllCourses(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return (snapshot.data == null || snapshot.data.isEmpty)
                ? Container()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return courses(
                        courses: snapshot.data[index],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => Coursesedtails(
                                courses: snapshot.data[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void showAlertDialog(BuildContext context) {

    showDialog(
        context: context,
       builder: (context) {
          return CupertinoAlertDialog(
            title: Text("تسجيل الدخول ؟"),
            content: Text( " للاشتراك يرجى تسجيل الدخول , اولا"),
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child:  Text("إلغاء"),
              ),
              CupertinoDialogAction(
                  textStyle: TextStyle(color: Colors.red),
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    //   SharedPreferences prefs = await SharedPreferences.getInstance();
                    //    prefs.remove('isLogin');
                       Navigator.pushReplacement(context,
                           MaterialPageRoute(builder: (BuildContext ctx) => LogIn()));
                  },
                  child:  Text("تسجيل الدخول"),
              ),
            ],
          );
       });
  }



  Widget show() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("  تم تنفيذ طلبك بنجاح يمكنك الآن الإستمتاع بما قمت بشراءه فوراً"),
    ));
  }




  Future<void> showAlertSucessDialog(BuildContext context ,String message) async{

    await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content:  Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: (){
                  Navigator.pop(context);
                },
                child:  Text("إلغاء"),
              ),
              CupertinoDialogAction(
                textStyle: TextStyle(color: Colors.red),
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);

                },
                child:  Text("استمرار"),
              ),
            ],
          );
        });
  }

  postFreeCourses(courseId){
    return FutureBuilder (

      future: catchFreeCourseApi(courseId),

      builder: (context, snapshot, ) {

        if (snapshot.hasData) {

          return (snapshot.data == null)
              ? Container()
              : showAlertSucessDialog(context, snapshot.data['message']);
        } else {
          return Container();
        }
      },
    );
  }
  freeCorsesSections() {
    return FutureBuilder (
      future: CoursesApi.freeCourses(),
      builder: (context, snapshot, ) {
        if (snapshot.hasData) {
          return (snapshot.data == null)
              ? Container()
             : InkWell(
                  onTap: () {
                    if(User.userid != null){
                      postFreeCourses(snapshot.data.id);
                      show();
                     // showAlertSucessDialog(context, snapshot.data['message']);
                    }else{
                      showAlertDialog(context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: customColor,
                    ),
                    child: Center(
                      child: Text(
                        'سجل الان',
                        style: AppTheme.heading.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }

  courses({int index, Function onTap, Courses courses}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 190,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: customCachedNetworkImage(
                  context: context,
                  url: courses.image,
                ),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: 200,
              child: Text(
                courses.name,
                style: AppTheme.headingColorBlue.copyWith(fontSize: 12),
              ),
            ),
            SizedBox(height: 5),
            RatingStar(
              rating: double.parse(courses.totalRating.toString()),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                (courses.newPrice == null)
                    ? Container()
                    : Text(
                        '${courses.newPrice}\$',
                        style: AppTheme.headingColorBlue.copyWith(
                          fontSize: 12,
                          color: customColor,
                        ),
                      ),
                SizedBox(width: 5),
                Text(
                  (courses.oldPrice == null)
                      ? Container()
                      : (courses.oldPrice != '0')
                          ? '${courses.oldPrice}\$'
                          : "مجاناً",
                  style: AppTheme.headingColorBlue.copyWith(
                    fontSize: 10,
                    color:
                        (courses.newPrice == null) ? customColor : Colors.black,
                    decoration: (courses.newPrice == null)
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container sectionTitle({String title, Function onTap}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTheme.heading.copyWith(fontSize: 16),
            ),
          ),
          // TextButton(
          //   onPressed: onTap,
          //   child: Text(
          //     'عرض المزيد',
          //     style: AppTheme.subHeading.copyWith(
          //       fontSize: 12,
          //       color: customColorGray,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  homeBaner() {
    return FutureBuilder(
      future: ProChartVIPModelsApi.futchProChartVIP(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return (snapshot.data == null && snapshot.data == '')
              ? Container()
              : (snapshot.data.homeAdImage == '' ||
                      snapshot.data.homeAdImage == null)
                  ? Container()
                  : Container(
                      height: 120,
                      padding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                      child: customCachedNetworkImage(
                        context: context,
                        url: snapshot.data.homeAdImage,
                      ),
                    );
        } else {
          return Container();
        }
      },
    );
  }




  /// **********************************************************************************

  getPurchaseButton(productKeyId){
    if (_loading) {
      return Card(
          child: (ListTile(
              leading:CircularProgressIndicator.adaptive(),
              title: Directionality(textDirection: TextDirection.rtl,child: Text(' !!! ')))));
    }
    if (!_isAvailable) {
      return Card();
    }
    final ListTile productHeader = ListTile(title: Directionality(textDirection: TextDirection.rtl,child: Text('منتجات للبيع')));
    List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      // productList.add(ListTile(
      //     title: Text('[${_notFoundIds.join(", ")}] not found',
      //         style: TextStyle(color: ThemeData.light().errorColor)),
      //     subtitle: Text(
      //         'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }

    Map<String, PurchaseDetails> purchases =
    Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    var _product;
    for (_product in _products) {
      print(_product);
      if(_product.id == productKeyId){
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: customColor,
          onPressed: () {
            PurchaseParam purchaseParam = PurchaseParam(
                productDetails: _product,
                applicationUserName: null,
                sandboxTesting: true);
            _connection.buyNonConsumable(
                purchaseParam: purchaseParam);

          },
          child: Text(
            'سجل الاّن',
            style: AppTheme.heading.copyWith(color: Colors.white),
          ),
        );


      }
    }

    return Container();
  }


  Card _buildConnectionCheckTile() {
    if (_loading) {
      return Card(child: ListTile(title: Directionality(textDirection: TextDirection.rtl,child: const Text('اعداد محاولة الاتصال ٫٫٫ !'))));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
            'المتجر ' + (_isAvailable ? 'متاح الاّن' : 'غير متاح الاّن') + '.'),
      ),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll([
        Divider(),
        ListTile(
          title: Text('غير متصل',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }
  Card _buildProductList() {
    if (_loading) {
      return Card(
          child: (ListTile(
              leading:CircularProgressIndicator.adaptive(),
              title: Directionality(textDirection: TextDirection.rtl,child: Text(' اعداد المنتجات المتاحة ٫٫! ')))));
    }
    if (!_isAvailable) {
      return Card();
    }
    final ListTile productHeader = ListTile(title: Directionality(textDirection: TextDirection.rtl,child: Text('منتجات للبيع')));
    List<ListTile> productList = <ListTile>[];
    /// Build List of Sliders
    List<CarouselSlider> productLists = <CarouselSlider>[];
    if (_notFoundIds.isNotEmpty) {
      // productList.add(ListTile(
      //     title: Text('[${_notFoundIds.join(", ")}] not found',
      //         style: TextStyle(color: ThemeData.light().errorColor)),
      //     subtitle: Text(
      //         'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    Map<String, PurchaseDetails> purchases =
    Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(_products.map(
          (ProductDetails productDetails) {
        PurchaseDetails previousPurchase = purchases[productDetails.id];
        return ListTile(
            title: Text(
              returnPlanTitle(productDetails.id),
            ),
            subtitle: Text(
              returnPlanDescription(productDetails.id),
            ),
            trailing: previousPurchase != null
                ? Icon(Icons.check)
                : TextButton(
              child: Text(productDetails.price),
              style: TextButton.styleFrom(
                backgroundColor: customColor,
                primary: Colors.white,
              ),

              onPressed: () {

                PurchaseParam purchaseParam = PurchaseParam(
                    productDetails: productDetails,
                    applicationUserName: null,
                    sandboxTesting: true);
                if (productDetails.id == _kConsumableId) {
                  _connection.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: _kAutoConsume || Platform.isIOS);
                } else{
                  _connection.buyNonConsumable(
                      purchaseParam: purchaseParam);
                }
                // TODO:: TESTING OTHERS FEATURES   ///////////
                if (productDetails.id == _kNonRenewingFreeCourseId ){
                  _connection.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: _kAutoConsume || Platform.isIOS);
                } else{
                  _connection.buyNonConsumable(
                      purchaseParam: purchaseParam);
                }
                if (productDetails.id == _kNonRenewingGoldenId ){
                  _connection.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: _kAutoConsume || Platform.isIOS);
                } else{
                  _connection.buyNonConsumable(
                      purchaseParam: purchaseParam);
                }
                if (productDetails.id == _kNonRenewingManageCapitalId){
                  _connection.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: _kAutoConsume || Platform.isIOS);
                } else{
                  _connection.buyNonConsumable(
                      purchaseParam: purchaseParam);
                }
                if (productDetails.id == _kNonRenewingYourStrategyId ){
                  _connection.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: _kAutoConsume || Platform.isIOS);
                } else{
                  _connection.buyNonConsumable(
                      purchaseParam: purchaseParam);
                }
                if (productDetails.id == _kNonRenewingProAnalysisId){
                  _connection.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: _kAutoConsume || Platform.isIOS);
                } else{
                  _connection.buyNonConsumable(
                      purchaseParam: purchaseParam);
                }
                if (productDetails.id == _kNonRenewingPrinciplesId){
                  _connection.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: _kAutoConsume || Platform.isIOS);
                } else{
                  _connection.buyNonConsumable(
                      purchaseParam: purchaseParam);
                }
                if (productDetails.id == _kNonRenewingSilverId){
                  _connection.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: _kAutoConsume || Platform.isIOS);
                } else{
                  _connection.buyNonConsumable(
                      purchaseParam: purchaseParam);
                }


              },
            ));
      },
    ));

    return Card(
        child:
        Column(children: <Widget>[productHeader, Divider()] + productList));
  }
  returnPlanTitle(id) {
    if(id == 'bronze') {
      return 'الخطة البرونزية';
    }
    if(id == 'golden') {
      return 'الخطة الذهبية';
    }
    if(id == 'manag_capitale') {
      return 'ادارة راس المال';
    }
    if(id == 'principles') {
      return 'اساسيات الفوركس';
    }
    if(id == 'pro_analisys') {
      return 'احترافية التحليل';
    }
    if(id == 'silver') {
      return 'الخطة الفضية';
    }
    if(id == 'your_strategy') {
      return 'استراتيجيتك';
    }

    return 'عنوان';
  }
  returnPlanDescription(id) {
    if(id == 'bronze') {
      return 'اشتراك يشمل قسم التعليم والمدونة';
    }
    if(id == 'golden') {
      return 'كافة المميزات';
    }
    if(id == 'manag_capitale') {
      return 'تعلم كيفية إدارة رأس المال المتداول';
    }
    if(id == 'principles') {
      return 'تعلم اساسيات التداول في منصة الفوركس';
    }
    if(id == 'pro_analisys') {
      return 'تعلم كيف تكون محلل فوركس محترف';
    }
    if(id == 'silver') {
      return 'دورة خاصة في إدارة رأس المال';
    }
    if(id == 'your_strategy') {
      return 'تعلم كيفية بناء استراتيجيات التداول';
    }

    return 'تفاصيل';
  }
  Card _buildConsumableBox() {
    if (_loading) {
      return Card(
          child: (ListTile(
              leading:CircularProgressIndicator.adaptive(),
              title: Directionality(textDirection: TextDirection.rtl, child: Text('إحضار المواد الاستهلاكية .. !')))));
    }
    if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
      return Card();
    }
    // TODO:: CHECK PURCHASES AVAILABILITY
    if (!_isAvailable || _notFoundIds.contains(_kNonRenewingFreeCourseId)) {
      return Card();
    }
    if (!_isAvailable || _notFoundIds.contains(_kNonRenewingSilverId)) {
      return Card();
    }
    if (!_isAvailable || _notFoundIds.contains(_kNonRenewingYourStrategyId)) {
      return Card();
    }
    if (!_isAvailable || _notFoundIds.contains(_kNonRenewingProAnalysisId)) {
      return Card();
    }
    if (!_isAvailable || _notFoundIds.contains(_kNonRenewingPrinciplesId)) {
      return Card();
    }
    if (!_isAvailable || _notFoundIds.contains(_kNonRenewingManageCapitalId)) {
      return Card();
    }
    if (!_isAvailable || _notFoundIds.contains(_kNonRenewingGoldenId)) {
      return Card();
    }
    // final ListTile consumableHeader = ListTile(title: Text('Purchased consumables'));
/*    final List<Widget> tokens = _consumables.map((String id) {
      // return GridTile(
      //   child: IconButton(
      //     icon: Icon(
      //       Icons.stars,
      //       size: 42.0,
      //       color: Colors.orange,
      //     ),
      //     splashColor: Colors.yellowAccent,
      //     onPressed: () => consume(id),
      //   ),
      // );
    }).toList();
    // return Card(
    //     child: Column(children: <Widget>[
    //       consumableHeader,
    //       Divider(),
    //       GridView.count(
    //         crossAxisCount: 5,
    //         children: tokens,
    //         shrinkWrap: true,
    //         padding: EdgeInsets.all(16.0),
    //       )
    //     ]));*/



  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }
  // ****************************************

  Future<void> freeCourses(String id) async {
    await ConsumableStore.FreeCourse(id);
    final List<String> consumables = await ConsumableStore.loadFreeCourse();
    setState(() {
      _consumables = consumables;
    });
  }
  Future<void> golden(String id) async {
    await ConsumableStore.Golden(id);
    final List<String> consumables = await ConsumableStore.loadGolden();
    setState(() {
      _consumables = consumables;
    });
  }
  Future<void> sliver(String id) async {
    await ConsumableStore.Sliver(id);
    final List<String> consumables = await ConsumableStore.loadSilver();
    setState(() {
      _consumables = consumables;
    });
  }
  Future<void> proAnalysis(String id) async {
    await ConsumableStore.ProAnalysis(id);
    final List<String> consumables = await ConsumableStore.loadProAnalysis();
    setState(() {
      _consumables = consumables;
    });
  }
  Future<void> yourStrategy(String id) async {
    await ConsumableStore.YourStrategy(id);
    final List<String> consumables = await ConsumableStore.loadYourStrategy();
    setState(() {
      _consumables = consumables;
    });
  }
  Future<void> principles(String id) async {
    await ConsumableStore.Principles(id);
    final List<String> consumables = await ConsumableStore.loadPrinciples();
    setState(() {
      _consumables = consumables;
    });
  }
  Future<void> manageCapital(String id) async {
    await ConsumableStore.ManageCapital(id);
    final List<String> consumables = await ConsumableStore.loadManageCapital();
    setState(() {
      _consumables = consumables;
    });
  }

  // ****************************************

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }

    /*     *************************************************************    */
    if (purchaseDetails.productID == _kNonRenewingFreeCourseId) {
      await ConsumableStore.saveFreeCourse(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.loadFreeCourse();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }

    if (purchaseDetails.productID == _kNonRenewingGoldenId) {
      await ConsumableStore.saveGolden(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.loadGolden();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }

    if (purchaseDetails.productID == _kNonRenewingManageCapitalId) {
      await ConsumableStore.saveManageCapital(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.loadManageCapital();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }

    if (purchaseDetails.productID == _kNonRenewingPrinciplesId) {
      await ConsumableStore.savePrinciples(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.loadPrinciples();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }

    if (purchaseDetails.productID == _kNonRenewingProAnalysisId) {
      await ConsumableStore.saveAnalysis(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.loadProAnalysis();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }

    if (purchaseDetails.productID == _kNonRenewingSilverId) {
      await ConsumableStore.saveSliver(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.loadSilver();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }

    if (purchaseDetails.productID == _kNonRenewingYourStrategyId) {
      await ConsumableStore.saveYourStrategy(purchaseDetails.purchaseID);
      List<String> consumables = await ConsumableStore.loadYourStrategy();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }

    /*      ********************************************************       */
  }

  kShowToast({String mes}){
    return  Fluttertoast.showToast(
        msg: mes,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  /// *********************** CREATE YOUR REQUEST HERE ***********************

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        PurchasedApi.fetchPurchases(purchaseDetails.productID);

        /// *************************** Call API HERE *****************************


        showPendingUI();
        kShowToast(mes: 'Process pending');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {

          /// *************************** Call API HERE ****************************

          handleError(purchaseDetails.error);
          kShowToast(mes: 'Process error');

        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);

          /// *************************** Call API HERE ****************************

          if (valid) {
            deliverProduct(purchaseDetails);
            kShowToast(mes: 'Process purchased');
          } else {
            _handleInvalidPurchase(purchaseDetails);
            kShowToast(mes: 'Process not purchased');

            return;
          }
        }
        if (Platform.isIOS ) {
          if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }

        // ********************************** //

        if(Platform.isIOS  ) {
          if (!_kAutoConsume && purchaseDetails.productID == _kNonRenewingFreeCourseId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if(Platform.isIOS  ) {
          if (!_kAutoConsume && purchaseDetails.productID == _kNonRenewingGoldenId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if(Platform.isIOS  ) {
          if (!_kAutoConsume && purchaseDetails.productID == _kNonRenewingManageCapitalId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if(Platform.isIOS  ) {
          if (!_kAutoConsume && purchaseDetails.productID == _kNonRenewingPrinciplesId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if(Platform.isIOS  ) {
          if (!_kAutoConsume && purchaseDetails.productID == _kNonRenewingProAnalysisId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if(Platform.isIOS  ) {
          if (!_kAutoConsume && purchaseDetails.productID == _kNonRenewingYourStrategyId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if(Platform.isIOS  ) {
          if (!_kAutoConsume && purchaseDetails.productID == _kNonRenewingSilverId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }

        //*************************************

        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }
/// ****************************************************************************

}
