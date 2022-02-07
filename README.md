# Al-Mosawi - Techno Masr

- # The IN APP PURCHASE

- https://pub.dev/packages/in_app_purchase/versions/0.3.5+1

- # Initiate Keys

  * const bool _kAutoConsume = true;
  * const String _kConsumableId = 'bronze';
  * const String _kNonRenewingFreeCourseId = 'freecourse';
  * const String _kNonRenewingGoldenId = 'golden';
  * const String _kNonRenewingManageCapitalId = 'manag_capitale';
  * const String _kNonRenewingPrinciplesId = 'principles';
  * const String _kNonRenewingProAnalysisId = 'pro_analisys';
  * const String _kNonRenewingSilverId = 'silver';
  * const String _kNonRenewingYourStrategyId = 'your_strategy'; 
  
- # Put keys in list to access there's in anywhere  

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
  
- # Call InAppPurchaseConnection in app & Subscribe to any incoming purchases 
  
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<dynamic> _subscription;

  - 
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError ;
  
  
# Integration 
  
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
   // do someThing
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
  
- # Call  Function Based on your api services 
    getPurchaseButton(snapshot.data[index].ios_product_id.toString()),


# Postman Collection .
https://technomasr.com/Demos/almosawi/api
