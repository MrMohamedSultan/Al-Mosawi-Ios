import 'dart:async';
import 'dart:io';

import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/plansApi.dart';
import 'package:ahmad_pro/models/prodact.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/secreens/authenticate/logIn/login.dart';
import 'package:ahmad_pro/secreens/in_app_purchases/consumable_store.dart';
import 'package:ahmad_pro/secreens/in_app_purchases/data.dart';
import 'package:ahmad_pro/secreens/in_app_purchases/purchases_integrtions.dart';
import 'package:ahmad_pro/services/dbhelper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// export 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart'

import '../../sharedPreferences.dart';

class ChoosePlan extends StatefulWidget {
  @override
  _ChoosePlanState createState() => _ChoosePlanState();
}

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

class _ChoosePlanState extends State<ChoosePlan> {
 // InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
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
  /// ******************************************************************************************* */
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

  int _currentPage = 0;
  bool loading = false;
  DbHehper helper;
  getBuyPlan() async {
    User.userSkipLogIn = await MySharedPreferences.getUserSkipLogIn();
    User.userCantBuy = await MySharedPreferences.getUserCantBuy();
  }

  @override
  void initState() {
    //initalize();
    getBuyPlan();

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


    super.initState();
    helper = DbHehper();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        primary: true,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          Center(
            child: Icon(
              FontAwesomeIcons.solidHandPointDown,
              color: customColor,
              size: 100,
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder(
            future: PlansApi.fetchAllPlans(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return (snapshot.data == null || snapshot.data.isEmpty)
                    ? Container(
                  child: Center(
                    child: Text(
                      'اسحب الشاشه لاسفل لاعاده التحويل ',
                      style: AppTheme.heading,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                    : CarouselSlider.builder(
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    height: 500,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index, i) {
                    return Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: (_currentPage == index)
                                ? Colors.transparent
                                : customColor,
                          ),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(15.0)),
                            child: Stack(
                              children: [
                                Container(
                                  width: 250,
                                  height: 500,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.only(
                                                topLeft: Radius.circular(
                                                  15,
                                                ),
                                                topRight: Radius.circular(
                                                  15,
                                                ),
                                              ),
                                              color: customColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                (snapshot.data[index].name
                                                    .toString()) ??
                                                    '',
                                                style: AppTheme.heading
                                                    .copyWith(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          (snapshot.data[index]
                                              .oldPrice ==
                                              null)
                                              ? Container()
                                              : Text(
                                            '${(snapshot.data[index].oldPrice) ?? ''} \$',
                                            style: AppTheme.heading
                                                .copyWith(
                                              color: customColor,
                                              fontSize: 20,
                                              fontWeight:
                                              FontWeight.w900,
                                            ),
                                          ),
                                          (snapshot.data[index].plan_time
                                              .toString() ==
                                              '')
                                              ? Container()
                                              : Text(
                                            'كل ' +
                                                (snapshot
                                                    .data[index]
                                                    .plan_time
                                                    .toString()) ??
                                                "",
                                            style: AppTheme.heading
                                                .copyWith(
                                              fontSize: 14,
                                              color: customColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      (snapshot.data[index].features
                                          .isEmpty ||
                                          snapshot.data[index]
                                              .features.isEmpty ==
                                              null)
                                          ? Container()
                                          : Card(
                                        elevation: 0,
                                        child: Container(
                                          height: 270,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            primary: false,
                                            padding: EdgeInsets
                                                .symmetric(
                                                horizontal: 10),
                                            itemCount: snapshot
                                                .data[index]
                                                .features
                                                .length,
                                            itemBuilder:
                                                (context, i) {
                                              return Column(
                                                children: [
                                                  contant(
                                                    title: snapshot
                                                        .data[index]
                                                        .features[
                                                    i]['txt'],
                                                    status: snapshot
                                                        .data[index]
                                                        .features[
                                                    i]['status'],
                                                  ),
                                                  Divider(
                                                    color:
                                                    customColorDivider,
                                                    thickness: 2,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      // ignore: deprecated_member_use
                                      getPurchaseButton(snapshot.data[index].ios_product_id.toString()),
                                      // RaisedButton(
                                      //   shape: RoundedRectangleBorder(
                                      //     borderRadius:
                                      //     BorderRadius.circular(30),
                                      //   ),
                                      //   color: customColor,
                                      //   onPressed: () async {
                                      //     print('userSkipLogIn' +
                                      //         User.userSkipLogIn
                                      //             .toString());
                                      //     if (User.userCantBuy == true) {
                                      //       sikpDialog(context: context);
                                      //     } else {
                                      //       if (User.userBuyPlan ==
                                      //           true) {
                                      //         cardDialog(
                                      //             context: context,
                                      //             message:
                                      //             'انت بالفعل مشترك في خطه عليك استكمال عمليه الاشاراك اول او حذف الخطه من السله حتي تسطيع الاشتراك في خطة اخري');
                                      //       } else {
                                      //         {
                                      //           setState(() {
                                      //             MySharedPreferences
                                      //                 .saveUserPayPlan(
                                      //                 true);
                                      //
                                      //             increaseCartTotlaPrice(
                                      //               price: (snapshot
                                      //                   .data[
                                      //               index]
                                      //                   .newPrice ==
                                      //                   null)
                                      //                   ? double.parse(
                                      //                   snapshot
                                      //                       .data[
                                      //                   index]
                                      //                       .oldPrice
                                      //                       .toString())
                                      //                   : double.parse(
                                      //                   snapshot
                                      //                       .data[
                                      //                   index]
                                      //                       .newPrice
                                      //                       .toString()),
                                      //             );
                                      //           });
                                      //           ConsultantProdect
                                      //           prodect =
                                      //           ConsultantProdect({
                                      //             'consultantId': snapshot
                                      //                 .data[index].id,
                                      //             'type': 'plan',
                                      //             'date': '',
                                      //             'dateId': 0,
                                      //             'time': '',
                                      //             'title': snapshot
                                      //                 .data[index].name,
                                      //             'price': (snapshot
                                      //                 .data[index]
                                      //                 .newPrice ==
                                      //                 null)
                                      //                 ? double.parse(
                                      //                 snapshot
                                      //                     .data[index]
                                      //                     .oldPrice
                                      //                     .toString())
                                      //                 : double.parse(
                                      //                 snapshot
                                      //                     .data[index]
                                      //                     .newPrice
                                      //                     .toString()),
                                      //             'proImageUrl': '',
                                      //           });
                                      //           // ignore: unused_local_variable
                                      //           int id = await helper
                                      //               .createProduct(
                                      //             prodect,
                                      //           );
                                      //           cardDialog(
                                      //             context: context,
                                      //           );
                                      //         }
                                      //       }
                                      //     }
                                      //   },
                                      //   child: Text(
                                      //     'اشترك الان',
                                      //     style: AppTheme.heading
                                      //         .copyWith(
                                      //         color: Colors.white),
                                      //   ),
                                      // ),
                                      SizedBox(height: 3),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  contant({String title, String status}) {
    return Container(
        height: 20,
        // width: 300,
        // color: Colors.black,
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: (status == '1') ? BoxShape.circle : BoxShape.rectangle,
                color: (status == '1') ? Colors.green : Colors.red,
              ),
              child: Center(
                child: Icon(
                  (status == '1') ? FontAwesomeIcons.check : Icons.close,
                  color: Colors.white,
                  size: (status == '1') ? 10 : 20,
                ),
              ),
            ),
            SizedBox(height: 20, width: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width - 193,
              child: Text(
                (title.toString()) ?? '',
                style: AppTheme.heading.copyWith(
                  fontSize: 12,
                ),
              ),
            )
          ],
        ));
  }


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
          borderRadius:
          BorderRadius.circular(30),
        ),
        color: customColor,
        onPressed: ()  {
          if(User.userid != null){
            PurchaseParam purchaseParam = PurchaseParam(
                productDetails: _product,
                applicationUserName: null,
                sandboxTesting: true);
            if (_product.id == _kConsumableId) {
              _connection.buyConsumable(
                  purchaseParam: purchaseParam,
                  autoConsume: _kAutoConsume || Platform.isIOS);
            } else{
              _connection.buyNonConsumable(
                  purchaseParam: purchaseParam);
            }
          }else{
            showAlertDialog(context);
          }




          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) =>  Integrations()),
          // );


          // _buyProduct(bronze);
          // print('userSkipLogIn' +
          //     User.userSkipLogIn
          //         .toString());
          // if (User.userCantBuy == true) {
          //   sikpDialog(context: context);
          // } else {
          //   if (User.userBuyPlan ==
          //       true) {
          //     cardDialog(
          //         context: context,
          //         message:
          //             'انت بالفعل مشارك في خطه عليك استكمال عمليه الاشاراك اول او حذف الخطه من السله حتي تسطيع الاشتراك في خطة اخري');
          //   } else {
          //     {
          //       setState(() {
          //         MySharedPreferences
          //             .saveUserPayPlan(
          //                 true);

          //         increaseCartTotlaPrice(
          //           price: (snapshot
          //                       .data[
          //                           index]
          //                       .newPrice ==
          //                   null)
          //               ? double.parse(
          //                   snapshot
          //                       .data[
          //                           index]
          //                       .oldPrice
          //                       .toString())
          //               : double.parse(
          //                   snapshot
          //                       .data[
          //                           index]
          //                       .newPrice
          //                       .toString()),
          //         );
          //       });
          //       ConsultantProdect
          //           prodect =
          //           ConsultantProdect({
          //         'consultantId': snapshot
          //             .data[index].id,
          //         'type': 'plan',
          //         'date': '',
          //         'dateId': 0,
          //         'time': '',
          //         'title': snapshot
          //             .data[index].name,
          //         'price': (snapshot
          //                     .data[index]
          //                     .newPrice ==
          //                 null)
          //             ? double.parse(
          //                 snapshot
          //                     .data[index]
          //                     .oldPrice
          //                     .toString())
          //             : double.parse(
          //                 snapshot
          //                     .data[index]
          //                     .newPrice
          //                     .toString()),
          //         'proImageUrl': '',
          //       });
          //       // ignore: unused_local_variable
          //       int id = await helper
          //           .createProduct(
          //         prodect,
          //       );
          //       cardDialog(
          //         context: context,
          //       );
          //     }
          //   }
          // }
        },
        child: Text(
          'اشترك الان',
          style: AppTheme.heading
              .copyWith(
              color: Colors.white),
        ),
      );
    }
  }

  return Container();
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
}
