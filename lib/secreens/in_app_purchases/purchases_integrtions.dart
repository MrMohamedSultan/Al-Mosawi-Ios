import 'dart:async';
import 'dart:io';

import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/secreens/home/home.dart';
import 'package:ahmad_pro/secreens/in_app_purchases/data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'consumable_store.dart';

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



class Integrations extends StatefulWidget {
  const Integrations({Key key}) : super(key: key);

  @override
  _IntegrationsState createState() => _IntegrationsState();
}

class _IntegrationsState extends State<Integrations> {
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

  @override
  void initState() {
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
    initStoreInfo();
    super.initState();
  }

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

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          children: [
            _buildConnectionCheckTile(),
            _buildProductList(),
            _buildConsumableBox(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: const ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child:CircularProgressIndicator.adaptive(),
            ),
          ],
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: customColor,
          actions: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
               /* Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  HomePages()),
                );*/
              },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward,),
                )),
          ],
          title: const Text('عمليات الشراء داخل التطبيق',),
        ),
        body: Stack(
          children: stack,
        ),
      ),
    );
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
